# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
#config.action_controller.perform_caching             = false

# Enable caching (otherwise Fleximage renders will be super slow)
config.action_controller.perform_caching             = false

# Mailer settings
config.action_mailer.raise_delivery_errors = false
config.action_mailer.perform_deliveries = false
config.action_mailer.delivery_method = :smtp
config.action_mailer.default_charset = "utf-8"

# SMTP settings
# NOTE: Postfix is configured to relay mail that originates from networks
# determined by the "mynetworks" parameter in postfix's config file
# /etc/postfix/main.cf
config.action_mailer.smtp_settings = {
  :address          => 'luna.qlogicinc.com',
  :port             => 25,
  :domain           => 'qlogicinc.com'
}

