class User < ApplicationRecord
  acts_as_authentic do |c|
    c.validate_login_field = false
  end

  has_many :bookmarks
  has_many :posts

  dragonfly_accessor :avatar

  def voted_for?(resource)
    resource.votes.map(&:user_id).include? id
  end

  def bookmarked?(resource)
    resource.bookmarks.map(&:user_id).include? id
  end

  def add_karma(count = 1)
    increment!(:karma, count)
  end

  def refresh_karma
    update_attribute(:karma, posts.sum(:votes_count))
  end
end
