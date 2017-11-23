class PostEvent < ApplicationRecord
  belongs_to :post

  scope :upcoming_first, -> { order(beginning_at: :asc) }
  scope :upcoming, -> { where('beginning_at > ?', Time.zone.now.end_of_day) }

  def can_be_synced?
    !synced_at.present? || (synced_at.present? && synced_at < 10.minutes.ago)
  end
end
