class ApiController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include CanCan::ControllerAdditions

  # Make sure the user is logged in
  before_filter :authenticate

  # Make sure the user is authorized (using CanCan)
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    render :json => {:error => "Access Denied"}, :status => 403
  end

protected

  #
  # Authentication
  #

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    user = authenticate_with_http_token do |t, o|
      @current_token = t

      User.from_access_token(t)
    end

    if user
      @current_user = user
    else
      request_http_token_authentication
    end
  end

  def current_user
    @current_user
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Memamug"'
    render json: {error: 'Bad credentials'}, status: 401
  end
end
