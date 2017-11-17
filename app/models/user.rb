class User < ApplicationRecord
  acts_as_authentic do |c|
    c.validate_login_field = false
  end

  has_many :bookmarks

  dragonfly_accessor :avatar

  def voted_for?(resource)
    resource.votes.map(&:user_id).include? id
  end

  def bookmarked?(resource)
    resource.bookmarks.map(&:user_id).include? id
  end
end
