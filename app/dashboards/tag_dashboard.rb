require "administrate/base_dashboard"

class TagDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    # taggings: Field::HasMany.with_options(class_name: "::ActsAsTaggableOn::Tagging"),
    id: Field::Number,
    name: Field::String,
    taggings_count: Field::Number,
    is_primary: Field::Boolean,
    slug: Field::String,
    hottness_mod: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    # :taggings,
    :id,
    :name,
    :taggings_count,
    :hottness_mod,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    # :taggings,
    :id,
    :name,
    :taggings_count,
    :is_primary,
    :slug,
    :hottness_mod
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    # :taggings,
    :name,
    :slug,
    :is_primary,
    :hottness_mod
  ].freeze

  # Overwrite this method to customize how tags are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(tag)
  #   "Tag ##{tag.id}"
  # end
end
