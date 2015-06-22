class Contact < ActiveRecord::Base
  has_many :photos, {dependent: :destroy}, -> { order created_at: :asc }
  has_and_belongs_to_many :reminder_mails

  accepts_nested_attributes_for :photos, allow_destroy: true

  validates :photos, presence: true
end
