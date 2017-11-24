class Post < ApplicationRecord
  include PgSearch

  PREVIEWABLE_MEDIA_TYPES = %w[youtube bandcamp_album].freeze

  has_many :comments, dependent: :destroy
  belongs_to :user
  has_one :event, class_name: :PostEvent, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy

  acts_as_taggable
  dragonfly_accessor :thumb

  scope :this_week, -> { where('created_at > ?', Time.zone.now - 1.week) }
  scope :last_two_weeks, -> { where('created_at > ?', Time.zone.now - 2.weeks) }
  scope :this_month, -> { where('created_at > ?', Time.zone.now - 1.month) }
  scope :this_year, -> { where('created_at > ?', Time.zone.now - 1.year) }
  scope :recent_first, -> { order(created_at: :desc) }
  scope :upcoming_events, -> { joins(:event).order('post_events.beginning_at ASC').where('post_events.beginning_at >= ?', Time.zone.now.beginning_of_day) }
  scope :past_events, -> { joins(:event).order('post_events.beginning_at ASC').where('post_events.beginning_at < ?', Time.zone.now.beginning_of_day) }

  pg_search_scope :search, against: :title, using: { tsearch: { prefix: true } }

  before_save :set_token

  def self.hot
    Post
      .select('posts.*, (((posts.votes_count - 1 + posts.comments_count * 3) / POW(((EXTRACT(EPOCH FROM (now()-posts.created_at)) / 3600)::integer + 2), 1.5))) AS hottness')
      .order('hottness DESC')
  end

  def self.popular
    Post
      .select('posts.*, (posts.votes_count + posts.comments_count) AS popularity')
      .order('popularity DESC')
  end

  # @todo Move that to decorator
  def path
    slug = title.truncate(60, omission: '').to_slug.normalize.to_s

    Rails.application.routes.url_helpers.post_path(token: token, slug: slug)
  end

  def has_media?
    media_type.present? && media_guid.present?
  end

  def media_previewable?
    PREVIEWABLE_MEDIA_TYPES.include? media_type
  end

  def user_voted?(user)
    user.present? ? votes.map(&:user_id).include?(user.id) : false
  end

  def user_bookmarked?(user)
    user.present? ? bookmarks.map(&:user_id).include?(user.id) : false
  end

  private

  def set_token
    self.token ||= SecureRandom.base58(6)
  end
end
