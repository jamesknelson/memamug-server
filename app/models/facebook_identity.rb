class FacebookIdentity < Identity
  def self.find_or_create_by_api_token(token)
    client = build_client(token)
    profile = client.get_object("me", fields: "id,first_name,last_name,email")

    identity = where(uid: profile['id']).first

    # Don't run with expired access tokens
    if identity and identity.expires_at < Time.now
      identity.destroy!
      identity = nil
    end

    unless identity
      # This facebook user isn't already linked to an account
      exchanged = FBOAuth.exchange_access_token_info(token)
      identity_options = {
        type: 'FacebookIdentity',
        uid: profile['id'],
        api_token: exchanged['access_token'],
        expires_at: exchanged['expires'].to_i.seconds.from_now
      }

      if user = User.find_by_email(profile['email'])
        # The user has an account already - link the new FB account
        identity = user.identities.create!(identity_options)
      else
        # Need to create a new user
        user = User.new(
          first_name: profile['first_name'],
          last_name: profile['last_name'],
          email: profile['email']
        )
        identity = user.identities.build(identity_options)
        user.save!
      end
    end

    identity
  end

  def self.build_client(token)
    graph = Koala::Facebook::API.new(
      token,
      Rails.application.secrets.facebook_api_secret
    )
  end

  def client
    @client ||= self.class.build_client(api_token)
  end 

  def fetch_avatar
    update!(
      avatar_url: client.get_picture("me"),
      avatar_url_fetched_at: Time.now
    )
  end
end
