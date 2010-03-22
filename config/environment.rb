# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# Constants needed for routing
SEARCHLOGIC_PARAMS_MAP = [
  { :key => :property_barrio_country_name_equals, :default_value => 'all' },
  { :key => :categories_name_equals, :default_value => 'property' },
  { :key => :listing_type_name_equals, :default_value => 'for sale or rent' },
  { :key => :property_barrio_market_name_equals,
    :default_value => 'any market' },
  { :key => :property_barrio_name_equals, :default_value => 'any barrio' },
  { :key => :ask_amount_less_than_or_equal_to,
    :default_value => 'under any amount' },
  { :key => :ask_amount_greater_than_or_equal_to,
    :default_value => 'over any amount' },
  { :key => :styles_name_equals, :default_value => 'any style' },
  { :key => :features_name_equals_any, :default_value => 'any feature' }
]
PAGINATE_PARAMS_MAP = [
  { :key => :page, :default_value => '1' },
  { :key => :order, :default_value => 'publish_date' },
  { :key => :order_dir, :default_value => 'desc' }
]
LISTING_PARAMS_MAP = SEARCHLOGIC_PARAMS_MAP + PAGINATE_PARAMS_MAP

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with
  # rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  
  # 2009-04-21 - Brian Warren
  config.gem 'friendly_id',
    :lib     => 'friendly_id',
    :source  => 'http://gems.github.com',
    :version => '~> 2.3.3'
    #:version => '~> 2.2.4'
  config.gem 'mislav-will_paginate',
    :lib     => 'will_paginate',
    :source  => 'http://gems.github.com',
    :version => '~> 2.3.11'
  config.gem 'authlogic',
    :lib     => 'authlogic',
    :source  => 'http://gems.github.com',
    :version => '~> 2.1.3'
  config.gem 'searchlogic',
    :lib     => 'searchlogic',
    :source  => 'http://gems.github.com',
    :version => '~> 2.4.12'
  config.gem 'subdomain-fu',
    :lib     => 'subdomain-fu',
    :source  => 'http://gems.github.com',
    :version => '0.5.4'
  config.gem 'db_populate',
    :lib     => 'db_populate',
    :source  => 'http://gems.github.com',
    :version => '0.2.5'

  # Only load the plugins named here, in the order given (default is
  # alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector,
  # :forum_observer
  config.active_record.observers = :information_request_observer

  # Set Time.zone default to the specified zone and make Active Record
  # auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from
  # config/locales/*.rb,yml are auto loaded.
  #config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # TODO: fix this! - Organize locale files according to Rails directory
  # structure
  # |-defaults
  # |---es.rb
  # |---en.rb
  # |-models
  # |---book
  # |-----es.rb
  # |-----en.rb
  # |-views
  # |---defaults
  # |-----es.rb
  # |-----en.rb
  # |---books
  # |-----es.rb
  # |-----en.rb
  #config.i18n.load_path += Dir[File.join(RAILS_ROOT, 'config', 'locales',
  #'**', '*.{rb,yml}')]
  config.i18n.default_locale = :en
  
  # 2009-06-01 Brian Warren
  # NOTE: Web server must be configured if non-default directory used here.
  # Default works without configuring web server:
  #   myapp/public
  # Consolidate caches in "cache" directory. Doesn't work unless web directory
  # is reconfigured:
  #   myapp/public/cache
  config.action_controller.page_cache_directory = File.join(
    Rails.root, 'public/cache'
  )
end
  
# SubdomainFu plugin configuration
SubdomainFu.tld_sizes = { :development => 2, :test => 1, :production => 1 }
SubdomainFu.mirrors = []
SubdomainFu.preferred_mirror = nil # Must be nil if NO subdomain is desired

# Constants
PRICE_RANGES = {
  'for sale' => [
    {
      :lower => 0,
      :upper => 100000,
      :label => 'Less than $100,000'
    },
    {
      :lower => 100000,
      :upper => 200000,
      :label => '$100,000 to $200,000'
    },
    {
      :lower => 200000,
      :upper => 500000,
      :label => '$200,000 to $500,000'
    },
    {
      :lower => 500000,
      :upper => false, # false indicates infinity
      :label => 'Over $500,000'
    }
  ],
  'for rent' => [
    {
      :lower => 0,
      :upper => 500,
      :label => 'Less than $500'
    },
    {
      :lower => 500,
      :upper => 1000,
      :label => '$500 to $1000'
    },
    {
      :lower => 1000,
      :upper => 2000,
      :label => '$1000 to $2000'
    },
    {
      :lower => 2000,
      :upper => false, # false indicates infinity
      :label => 'Over $2000'
    }
  ]
}
