class AccessToken < ActiveRecord::Base
  belongs_to :user

  before_create :initialize_access_token

  def initialize_access_token
    # The database has a uniqueness constraint on access_token - so in the x in
    # 64^16 chance we somehow generate an existing token, just let the
    # application error, and the user can try to login again.
    self.access_token = SecureRandom.base64

    self.expires_at = 60.days.from_now
  end
end
