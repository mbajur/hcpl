require "administrate/base_dashboard"

class PostEventDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    post: Field::BelongsTo,
    id: Field::Number,
    beginning_at: Field::DateTime,
    city: Field::String,
    country_code: Field::String,
    attendants_count: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    synced_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :post,
    :beginning_at,
    :city,
    :country_code,
    :attendants_count,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :post,
    :id,
    :beginning_at,
    :city,
    :country_code,
    :attendants_count,
    :created_at,
    :updated_at,
    :synced_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :post,
    :beginning_at,
    :city,
    :country_code,
    :synced_at,
  ].freeze

  # Overwrite this method to customize how post events are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(post_event)
  #   "PostEvent ##{post_event.id}"
  # end
end
