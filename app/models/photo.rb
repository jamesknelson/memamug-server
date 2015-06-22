class Photo < ActiveRecord::Base
  attr_accessor :image_content_type, :image_original_filename, :image_base64

  belongs_to :contact
  belongs_to :user

  has_attached_file :image,
    storage: :s3,
    styles: {
      thumb: ["40x40#", :jpg],
      small: ["150x150#", :jpg],
      medium: ["200x200#", :jpg]
    },
    url: ":s3_domain_url",
    path: "assets/:class/:id/:style.:extension",
    s3_protocol: "https",
    s3_permissions: :private,
    s3_credentials: {
      bucket: Rails.application.secrets.s3_bucket_name,
      access_key_id: Rails.application.secrets.s3_access_key_id,
      secret_access_key: Rails.application.secrets.s3_secret_access_key
    }

  before_validation :decode_base64_image

  validates_attachment :image,
    content_type: { content_type: "image/jpeg" },
    presence: true,
    size: { less_than: 2.megabytes }

protected
  # Create a temporary image file which paperclip can work with from the
  # base64 image which the client passes in
  def decode_base64_image
    if image_base64 and image_content_type and image_original_filename
      uri = URI::Data.new(image_base64)

      data = StringIO.new(uri.data)
      data.class_eval { attr_accessor :content_type, :original_filename }
      data.content_type = image_content_type
      data.original_filename = File.basename(image_original_filename)

      self.image = data
    end
  end

  def base64_url_decode(str)
    str += '=' * (4 - str.length.modulo(4))
    Base64.decode64(str.tr('-_','+/'))
  end
end

