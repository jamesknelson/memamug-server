class Api::UsersController < ApiController
  def show
    authorize! :read, current_user
    render json: current_user
  end
end
