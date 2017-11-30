require "administrate/base_dashboard"

class PostDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    comments: Field::HasMany,
    user: Field::BelongsTo,
    # event: Field::HasOne,
    votes: Field::HasMany,
    bookmarks: Field::HasMany,
    # taggings: Field::HasMany.with_options(class_name: "::ActsAsTaggableOn::Tagging"),
    # base_tags: Field::HasMany.with_options(class_name: "::ActsAsTaggableOn::Tag"),
    # tag_taggings: Field::HasMany.with_options(class_name: "ActsAsTaggableOn::Tagging"),
    # tags: Field::HasMany.with_options(class_name: "ActsAsTaggableOn::Tag"),
    id: Field::Number,
    link: Field::String,
    description: Field::Text,
    votes_count: Field::Number,
    comments_count: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    title: Field::String,
    token: Field::String,
    thumb_uid: Field::String,
    media_type: Field::String,
    media_guid: Field::String,
    tag_list: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :title,
    :comments,
    :user,
    # :event,
    :votes,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :comments,
    :user,
    # :event,
    :votes,
    :bookmarks,
    # :taggings,
    # :base_tags,
    # :tag_taggings,
    # :tags,
    :tag_list,
    :id,
    :link,
    :description,
    :votes_count,
    :comments_count,
    :created_at,
    :updated_at,
    :title,
    :token,
    :thumb_uid,
    :media_type,
    :media_guid,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    # :event,
    # :votes,
    # :bookmarks,
    # :tag_list,
    # :base_tags,
    # :tag_taggings,
    # :tags,
    :title,
    :link,
    :description,
    :user,
    :votes_count,
    :comments_count,
    :token,
    # :thumb_uid,
    :media_type,
    :media_guid,
  ].freeze

  # Overwrite this method to customize how posts are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(post)
  #   "Post ##{post.id}"
  # end
end
