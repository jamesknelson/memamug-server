class Auth::SessionsController < ApplicationController

  #rescue_from Koala::Facebook::AuthenticationError do |exception|
  #  render json: {provider: "facebook"}, status: 401
  #end

  def create
    if params[:provider] == 'facebook'
      identity = FacebookIdentity.find_or_create_by_api_token(params[:access_token])
    elsif params[:provider] == 'linkedin'
      identity = LinkedInIdentity.find_or_create_by_auth_code(params[:auth_code])
    end

    # Create a new access token for the newly logged in user    
    access_token = identity.user.access_tokens.create!

    render json: access_token, include: 'user'
  end

  def destroy
    token = AccessToken.find_by_access_token(@current_token)
    token.destroy!
    render json: {success: true}
  end
end
