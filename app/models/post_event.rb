class PostEvent < ApplicationRecord
  include PgSearch

  belongs_to :post

  scope :upcoming_first, -> { order(beginning_at: :asc) }
  scope :upcoming, -> { where('beginning_at > ?', Time.zone.now.beginning_of_day) }
  scope :past, -> { where('beginning_at < ?', Time.zone.now.beginning_of_day) }

  pg_search_scope :search, against: :city, associated_against: { post: :title }, using: { tsearch: { prefix: true } }

  def can_be_synced?
    !synced_at.present? || (synced_at.present? && synced_at < 10.minutes.ago)
  end
end
