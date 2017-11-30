require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    bookmarks: Field::HasMany,
    posts: Field::HasMany,
    id: Field::Number,
    email: Field::String,
    persistence_token: Field::String,
    single_access_token: Field::String,
    perishable_token: Field::String,
    login_count: Field::Number,
    failed_login_count: Field::Number,
    last_request_at: Field::DateTime,
    current_login_at: Field::DateTime,
    last_login_at: Field::DateTime,
    current_login_ip: Field::String,
    last_login_ip: Field::String,
    active: Field::Boolean,
    approved: Field::Boolean,
    confirmed: Field::Boolean,
    name: Field::String,
    username: Field::String,
    discourse_id: Field::Number,
    is_admin: Field::Boolean,
    is_moderator: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    avatar_uid: Field::String,
    karma: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :email,
    :username,
    :karma,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :username,
    :email,
    :persistence_token,
    :single_access_token,
    :perishable_token,
    :login_count,
    :failed_login_count,
    :last_request_at,
    :current_login_at,
    :last_login_at,
    :current_login_ip,
    :last_login_ip,
    :active,
    :approved,
    :confirmed,
    :discourse_id,
    :is_admin,
    :is_moderator,
    :created_at,
    :updated_at,
    :avatar_uid,
    :karma,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :email,
    :active,
    :approved,
    :confirmed,
    :name,
    :username,
    :discourse_id,
    :is_admin,
    :is_moderator,
    :karma,
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user)
  #   "User ##{user.id}"
  # end
end
