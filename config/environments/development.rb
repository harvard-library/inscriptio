Inscriptio::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  ROOT_URL = ENV['INSCRIPTIO_ROOT']

  config.eager_load = false
  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false


  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Don't actually send emails
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  config.action_mailer.default_url_options = { :host => ENV['INSCRIPTIO_ROOT'] }
  

  # Expands the lines which load the assets
  config.assets.debug = true

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Pry as development console
  silence_warnings do
    begin
      require 'pry'
      IRB = Pry
    rescue LoadError
    end
  end

end
