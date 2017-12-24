class Post < ApplicationRecord
  include PgSearch

  HOTTNESS_TIME_INTERVAL = 1
  HOTTNESS_COMMENTS_MODIFIER = 10
  HOTTNESS_TIME_WINDOW = 3.hour.to_i

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

  # Based on http://sorentwo.com/2013/12/30/let-postgres-do-the-work.html
  # Ruby method:
  #
  #   def post_popularity_score(post)
  #     epoch = 1.day.ago.to_i
  #     divisor = 3600
  #
  #     seconds = post.created_at.to_i - epoch
  #     recentness = (seconds / divisor).to_i
  #
  #     pop = post.votes_count + post.comments_count
  #     mod = post.tags.sum(:hottness_mod)
  #     pop + recentness + mod
  #   end
  #
  def self.hot
    sql = <<-SQL.squish
      posts.*,
      (
        /* Votes */
        votes_count +
        comments_count * #{HOTTNESS_COMMENTS_MODIFIER} +
        (
          (
            EXTRACT(EPOCH from created_at) -
            EXTRACT(EPOCH from (now() - interval '#{HOTTNESS_TIME_INTERVAL}' day))::integer
          ) / #{HOTTNESS_TIME_WINDOW}
        ) + (
          SELECT COALESCE(sum(tags.hottness_mod), 0)
          FROM tags
          INNER JOIN taggings
          on tags.id = taggings.tag_id
          WHERE
            taggings.taggable_id = posts.id
            AND
            taggings.taggable_type = 'Post'
            AND
            taggings.context = 'tags'
        )
      ) as hottness
    SQL

    Post
      .select(sql)
      .order('hottness DESC')

    # Post
    #   .select("posts.*, votes_count + comments_count * #{HOTTNESS_COMMENTS_MODIFIER} + ((EXTRACT(EPOCH from created_at) - EXTRACT(EPOCH from (now() - interval '#{HOTTNESS_TIME_INTERVAL}' day))::integer) / #{HOTTNESS_TIME_WINDOW}) as hottness")
    #   .order('hottness DESC')
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
