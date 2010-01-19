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

# Enable caching (otherwise Fleximage renders will be super slow)
config.action_controller.perform_caching             = true

# Mailer settings
config.action_mailer.raise_delivery_errors = false
config.action_mailer.perform_deliveries = false
config.action_mailer.delivery_method = :smtp
config.action_mailer.default_charset = "utf-8"

# SMTP settings
config.action_mailer.smtp_settings = {
  :address        => 'mail.barrioearth.com',
  :port           => 2525,
  :domain         => 'barrioearth.com',
  :authentication => :login,
  :user_name      => 'user_services+barrioearth.com',
  :password       => 'abr67b89'
}

# GMail settings
#config.action_mailer.smtp_settings = {
#  :address        => "smtp.gmail.com",
#  :port           => 587,
#  :domain         => "gmail.com",
#  :user_name      => "brian.scott.warren@gmail.com",
#  :password       => "abr67b89",
#  :authentication => :plain
#}

