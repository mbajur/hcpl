require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hcpl
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.eager_load_paths << "#{Rails.root}/lib"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Discourse SSO settings
    config.discourse_sso_url        = 'https://forum.hard-core.pl/session/sso_provider'
    config.discourse_sso_return_url = 'http://localhost:3000/auth/comeback'
    config.discourse_sso_secret     = '703a7637d17f1afea3ea62c83eabe1b088afbfc34929b13f0eb72043ccff7f361be925db2358ca8c4133ebd5529eb1e0cea311f1654e92fda16bc12c72ba4f10'
  end
end
