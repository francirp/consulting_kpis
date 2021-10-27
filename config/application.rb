require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ConsultingKpis
  class Application < Rails::Application
    config.load_defaults 5.0
    
    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_url_options = { :host => ENV['APPLICATION_ROOT_URL'] }
    config.action_mailer.perform_deliveries = true

    config.action_mailer.smtp_settings = {
      address: "smtp.mandrillapp.com",
      port: 587,
      domain: ENV['APPLICATION_ROOT_URL'],
      authentication: "plain",
      enable_starttls_auto: true,
      user_name: ENV['EMAIL'],
      password: ENV['EMAIL_PASSWORD']
    }

    # config.eager_load_paths << Rails.root.join("extras")
  end
end
