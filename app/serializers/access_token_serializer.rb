class AccessTokenSerializer < ApplicationSerializer
  belongs_to :user
  attributes :access_token, :expires_at
end
