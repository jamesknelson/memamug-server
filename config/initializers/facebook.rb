FBOAuth = Koala::Facebook::OAuth.new(
  Rails.application.secrets.facebook_api_key, 
  Rails.application.secrets.facebook_api_secret
)
