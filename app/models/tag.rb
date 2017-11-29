class Tag < ActsAsTaggableOn::Tag
  include PgSearch

  pg_search_scope :search, against: :name, using: { tsearch: { prefix: true } }
end
