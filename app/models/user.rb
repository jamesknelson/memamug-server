class User < ActiveRecord::Base
  SUBSCRIPTION_PERIODS = [1, 3, 7, 14, 27].map {|x| x.days}

  has_many :access_tokens, dependent: :destroy
  has_many :identities, dependent: :destroy, after_remove: :refetch_avatar
  has_many :contacts, dependent: :destroy
  has_many :reminder_mails, dependent: :destroy

  validates :email,
            uniqueness: true,
            format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  validates :first_name, :last_name,
            presence: true


  def self.from_access_token(access_token)
    User.joins(:access_tokens).
      where("access_tokens.access_token = ?", access_token).
      where("access_tokens.expires_at > now()").
      first
  end

  def reminder_contacts_for(date, except_attempted_on)
    subscription_dates = SUBSCRIPTION_PERIODS.map { |period| date - period }
    contacts
      .joins('''
        LEFT OUTER JOIN contacts_reminder_mails
          ON contacts_reminder_mails.contact_id = contacts.id
        LEFT OUTER JOIN reminder_mails
          ON reminder_mails.id = contacts_reminder_mails.reminder_mail_id
      ''')
      .where('(reminder_mails.created_at IS NULL) OR (reminder_mails.created_at::date <> ?)', except_attempted_on)
      .where('contacts.subscribed_on::date IN (?)', subscription_dates)
      .distinct
  end

  def refetch_avatar(identity)
    if identities.count > 0
      avatar_identity.fetch_avatar
    end
  end

  def avatar_identity
    identities.order(:created_at).first
  end

  def avatar_url
    avatar_identity.avatar_url
  end
end
