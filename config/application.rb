require File.expand_path('../boot', __FILE__)

require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Api
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Convert incoming/outgoing JSON between camelCase and snake_case
    config.middleware.insert_before ActionDispatch::ParamsParser, "InflectJson"

    # Allow API requests from the client, which isn't hosted at the same origin
    # config.middleware.insert_before 0, "Rack::Cors" do
    #   allow do
    #     origins 'localhost:9000', 'melaleuca.local:9000', 'learn.memamug.com'
    #     resource '*', :headers => :any, :methods => [:get, :post, :patch, :options]
    #   end
    # end

    config.active_record.raise_in_transactional_callbacks = true

    # Disable asset pipeline
    config.assets.enabled = false

    # Serve the app
    config.serve_static_files = true

    config.autoload_paths += %W(#{config.root}/app/serializers)
  end
end
