class PostEvent < ApplicationRecord
  include PgSearch

  belongs_to :post

  dragonfly_accessor :poster

  scope :upcoming_first, -> { order(beginning_at: :asc) }
  scope :upcoming, -> { where('beginning_at > ?', Time.zone.now.beginning_of_day) }
  scope :upcoming_4_months, -> { where('beginning_at > ?', Time.zone.now.beginning_of_day).where('beginning_at <= ?', Time.zone.now + 4.months) }
  scope :past, -> { where('beginning_at < ?', Time.zone.now.beginning_of_day) }
  scope :this_week, -> { where('beginning_at > ?', Time.zone.now.beginning_of_week).where('beginning_at <= ?', Time.zone.now.end_of_week) }
  scope :upcoming_hot, -> { where('beginning_at > ?', Time.zone.now.beginning_of_day).where('beginning_at <= ?', Time.zone.now + 25.days).where(is_hot: true) }
  scope :hot, -> { where(is_hot: true) }

  pg_search_scope :search, against: :city, associated_against: { post: :title }, using: { tsearch: { prefix: true } }

  def can_be_synced?
    !synced_at.present? || (synced_at.present? && synced_at < 10.minutes.ago)
  end
end
