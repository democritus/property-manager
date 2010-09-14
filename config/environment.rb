# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# Constants needed for routing

# Shorthand for long parameters corresponding with named scopes generated
# by Searchlogic plugin
ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO = :ask_amount_less_than_or_equal_to
ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO = :ask_amount_greater_than_or_equal_to

# Scopes that are translated from string key that comes in params into
# differently named scope in search_params
BEDROOM_NUMBER = :bedroom_number
BEDROOM_NUMBER_EQUALS = :property_bedroom_number_equals
BEDROOM_NUMBER_GTE = :property_bedroom_number_greater_than_or_equal_to
BEDROOM_NUMBER_LTE = :property_bedroom_number_less_than_or_equal_to
BATHROOM_NUMBER = :bathroom_number
BATHROOM_NUMBER_EQUALS = :property_bathroom_number_equals
BATHROOM_NUMBER_GTE = :property_bathroom_number_greater_than_or_equal_to
BATHROOM_NUMBER_LTE = :property_bathroom_number_less_than_or_equal_to

# TODO: make the named routes referenced by these parameters "id agnostic",
# where a friendly id OR regular id can be used
BARRIO_EQUALS = :property_barrio_cached_slug_equals
CANTON_EQUALS = :property_barrio_canton_cached_slug_equals
CATEGORIES_EQUALS_ANY = :categories_cached_slug_equals_any
CATEGORIES_EQUALS_ALL = :categories_cached_slug_equals_all
COUNTRY_EQUALS = :property_barrio_canton_province_country_cached_slug_equals
FEATURES_EQUALS_ALL = :features_cached_slug_equals_all_custom # Custom scope:
  # Searchlogic default didn't work right
LISTING_TYPE_EQUALS = :listing_type_cached_slug_equals
MARKET_EQUALS = :property_barrio_market_cached_slug_equals
PROVINCE_EQUALS = :property_barrio_canton_province_cached_slug_equals
STYLES_EQUALS_ANY = :styles_cached_slug_equals_any
STYLES_EQUALS_ALL = :styles_cached_slug_equals_all
ZONE_EQUALS = :property_barrio_canton_zone_cached_slug_equals

# Maps URL params in this order to Searchlogic named scopes
SEARCH_PARAMS_MAP = [
  {
    :key => COUNTRY_EQUALS,
    :null_equivalent => ['all'],
    :default => 'all',
    :required => true
  },
  {
    :key => CATEGORIES_EQUALS_ANY,
    :null_equivalent => ['property'],
    :default => 'property',
    :required => true
  },
  { 
    :key => LISTING_TYPE_EQUALS,
    :null_equivalent => ['for-sale-or-rent'],
    :default => 'for-sale',
    :required => true
  },
  { 
    :key => MARKET_EQUALS,
    :null_equivalent => ['any-market'],
    :default => 'any-market'
  },
  { 
    :key => BARRIO_EQUALS,
    :null_equivalent => ['any-barrio'],
    :default => 'any-barrio'
  },
  { 
    :key => CANTON_EQUALS,
    :null_equivalent => ['any-canton'],
    :default => 'any-canton'
  },
  { 
    :key => PROVINCE_EQUALS,
    :null_equivalent => ['any-province'],
    :default => 'any-province'
  },
  { 
    :key => ZONE_EQUALS,
    :null_equivalent => ['any-zone'],
    :default => 'any-zone'
  },
  { 
    :key => BEDROOM_NUMBER,
    :null_equivalent => ['any-bedroom-number'],
    :default => 'any-bedroom-number'
  },
  { 
    :key => BATHROOM_NUMBER,
    :null_equivalent => ['any-bathroom-number'],
    :default => 'any-bathroom-number'
  },
  { 
    :key => ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO,
    :null_equivalent => ['over-any-amount'],
    :default => 'over-any-amount'
  },
  { 
    :key => ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO,
    :null_equivalent => ['under-any-amount'],
    :default => 'under-any-amount'
  },
  { 
    :key => STYLES_EQUALS_ANY,
    :null_equivalent => ['any-style'],
    :default => 'any-style'
  },
  { 
    :key => FEATURES_EQUALS_ALL,
    :null_equivalent => ['any-feature'],
    :default => 'any-feature'
  }
]
PAGINATE_PARAMS_MAP = [
  {
    :key => :page,
    :null_equivalent => ['1', ''],
    :default => '1'
  },
  {
    :key => :order,
    :null_equivalent => [''],
    :default => 'publish_date desc'
  }
]
LISTING_PARAMS_MAP = SEARCH_PARAMS_MAP + PAGINATE_PARAMS_MAP
# Parameter keys that are sent to Searchlogic, but are implicit in the URL
# through another parameter
INTERNAL_PARAM_KEYS = [ BEDROOM_NUMBER_EQUALS, BEDROOM_NUMBER_GTE,
  BEDROOM_NUMBER_LTE, BATHROOM_NUMBER_EQUALS, BATHROOM_NUMBER_GTE,
  BATHROOM_NUMBER_LTE
]

js_pairs = []
LISTING_PARAMS_MAP.each do |pair|
  js_pairs << '{name: "' + pair[:key].to_s + '"' + ', null_equivalent: [' +
    pair[:null_equivalent].map { |x| "'#{x}'" }.join(',') + ']}'
end
JAVASCRIPT_LISTING_PARAMS_MAP = '[' + js_pairs.join(',') + ']'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with
  # rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6',
  #   :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  
  # 2009-04-21 - Brian Warren
  config.gem 'friendly_id',
    :lib     => 'friendly_id',
    :source  => 'http://gems.github.com',
    :version => '~> 3.0.4'
  config.gem 'will_paginate',
    :lib     => 'will_paginate',
    :source  => 'http://gems.github.com',
    :version => '~> 2.3.14'
  config.gem 'authlogic',
    :lib     => 'authlogic',
    :source  => 'http://gems.github.com',
    :version => '~> 2.1.6'
  config.gem 'searchlogic',
    :lib     => 'searchlogic',
    :source  => 'http://gems.github.com',
    :version => '~> 2.4.26'
  config.gem 'subdomain-fu',
    :lib     => 'subdomain-fu',
    :source  => 'http://gems.github.com',
    :version => '0.5.4'
  config.gem 'db_populate',
    :lib     => 'db_populate',
    :source  => 'http://gems.github.com',
    :version => '0.2.5'
  config.gem 'fleximage',
    :lib     => 'fleximage',
    :source  => 'http://gems.github.com',
    :version => '1.0.4'

  # Only load the plugins named here, in the order given (default is
  # alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # 2010-06-04 bsw
  # Need to include sweepers directory in rails paths
  config.load_paths += %W( #{RAILS_ROOT}/app/sweepers )
  
  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector,
  # :forum_observer
  config.active_record.observers = :information_request_observer
  
#  # DISABLED: sweepers used via controller callbacks instead to allow use
#  # of domain name as part of cache directory path
#  # 2010-06-04 bsw
#  # Add sweepers as observers
#  full_names = Dir["#{RAILS_ROOT}/app/sweepers/*.rb"]
#  config.active_record.observers = full_names.collect do |full_name|
#    File.basename(full_name,'.rb').to_sym
#  end
  
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
