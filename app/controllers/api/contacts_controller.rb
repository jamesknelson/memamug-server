class Api::ContactsController < ApiController
  def index
    authorize! :read, Contact
    @contacts = current_user.contacts
    render json: @contacts, include: 'photos'
  end

  def show
    @contact = current_user.contacts.find(params[:id])
    authorize! :read, @contact
    render json: @contact, include: 'photos'
  end

  def update
    @contact = current_user.contacts.find(params[:id])
    authorize! :update, @contact
    if @contact.update(contact_params)
      render json: @contact, status: 200, include: 'photos'
    else
      render json: @contact.errors.full_messages, status: 400
    end
  end

  def create
    @contact = current_user.contacts.build(contact_params)
    @contact.subscribed_on = Time.now
    authorize! :create, @contact
    if @contact.save
      render json: @contact, status: 201, include: 'photos'
    else
      render json: @contact.errors, status: 400
    end
  end

protected
  def contact_params
    params.permit(
      :display_name, :notes, :starred,
      photos_attributes: [:id, :image_content_type, :image_original_filename, :image_base64]
    )
  end

  def contact_photos_params
    params.require(:photos_attributes)
  end
end
