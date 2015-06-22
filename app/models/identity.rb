class Identity < ActiveRecord::Base
	belongs_to :user

  def fetch_avatar
    raise NotImplementedError.new("You must implement fetch_avatar")
  end

  def avatar_url
    fetch_avatar if !avatar_url_fetched_at or avatar_url_fetched_at < 1.day.ago  
    read_attribute :avatar_url
  end
end
