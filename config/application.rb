require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative '../lib/seo.rb'
require_relative '../lib/send_grid_action_mailer.rb'

ENV.update YAML.load(File.read(File.expand_path('../application.yml', __FILE__)))

module TicketFinders
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Mark page object as "fixed" by adding his path to array below.
    # Fixed pages protected from hiding, deleting and changing path.
    # Homepage (with empty path) is fixed by default.
    config.fixed_pages_paths = %w(
        messages/new
        static/about
        static/sport
        static/terms
      )
  end
end
