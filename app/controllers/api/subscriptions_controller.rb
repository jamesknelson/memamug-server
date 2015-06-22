class Api::SubscriptionsController < ApiController
  def destroy_all
    authorize! :update, Contact
    if current_user.contacts.update_all(subscribed_on: nil)
      render nothing: true, status: 200
    else
      render nothing: true, status: 400
    end
  end
end
