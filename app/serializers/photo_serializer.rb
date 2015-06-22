class PhotoSerializer < ApplicationSerializer
  attributes :id, :contact_id, :image

  def image
    {
      file_size: object.image_file_size,
      file_name: object.image_file_name,

      original_url: image_url("original"),
      medium_url: image_url("medium"),
      thumb_url: image_url("thumb")
    }
  end


protected
  def image_url(style)
    object.image.s3_object(style).url_for(:read).to_s
  end
end
