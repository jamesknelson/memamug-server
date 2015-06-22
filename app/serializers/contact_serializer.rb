class ContactSerializer < ApplicationSerializer
  attributes :id, :starred, :display_name, :notes, :subscribed_on

  has_many :photos
end
