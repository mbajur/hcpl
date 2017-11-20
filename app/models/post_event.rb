class PostEvent < ApplicationRecord
  belongs_to :post

  scope :upcoming_first, -> { order(beginning_at: :asc) }
  scope :upcoming, -> { where('beginning_at > ?', Time.zone.now.end_of_day) }
end
