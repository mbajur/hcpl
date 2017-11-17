class PostEvent < ApplicationRecord
  belongs_to :post

  scope :upcoming_first, -> { order(beginning_at: :asc) }
end
