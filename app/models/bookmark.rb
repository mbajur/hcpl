class Bookmark < ApplicationRecord
  belongs_to :bookmarkable, polymorphic: true
  belongs_to :user

  scope :recent_first, -> { order(created_at: :desc) }
end
