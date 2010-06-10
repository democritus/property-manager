class CreateDatabaseFromSchema < ActiveRecord::Migration

  def self.up
    create_table :agencies, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      # TODO: if agencies need to be associated with multiple countries,
      # a new lookup table will need to be created. Note that this country
      # is only used to facilitate associating markets and should not be
      # used to constrain listing results globally
      t.integer  :country_id, :null => false
      t.string   :name, :null => false
      t.string   :short_name, :null => false
      t.integer  :market_segment_id
      t.string   :domain
      t.string   :subdomain
      t.string   :email
      t.string   :skype
      t.integer  :broker_id
      t.text     :description
      t.boolean  :master_agency, :default => false, :null => false
      t.integer  :position
      t.string   :cached_slug
      t.timestamps
    end

    add_index :agencies, [:name], :name => "name", :unique => true
    add_index :agencies, [:country_id, :position],
      :name => "country_id__position"
    add_index :agencies, [:cached_slug], :name => "cached_slug"
    add_index :agencies, [:short_name], :name => "short_name",
      :unique => true
    add_index :agencies, [:domain, :subdomain], :name => "domain__subdomain",
      :unique => true

    create_table :agency_jurisdictions,
      :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer :market_id, :null => false
      t.integer :agency_id, :null => false
      t.boolean :primary_market, :default => false, :null => false
      t.boolean :primary_agency, :default => false, :null => false
      t.timestamps
    end

    add_index :agency_jurisdictions, [:agency_id, :market_id],
      :name => "agency_id__market_id", :unique => true
    add_index :agency_jurisdictions, [:market_id, :agency_id],
      :name => "market_id__agency_id"
    
    create_table :agency_relationships,
      :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer :agency_id, :null => false
      t.integer :partner_id, :null => false
      t.timestamps
    end

    add_index :agency_relationships, [:agency_id, :partner_id],
      :name => "agency_id__partner_id", :unique => true

    create_table :agents, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      t.integer  :user_id, :null => false
      t.text     :mini_biography
      t.timestamps
    end

    add_index :agents, [:user_id], :name => "user_id", :unique => true

    create_table :agent_affiliations,
      :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer :agency_id, :null => false
      t.integer :agent_id, :null => false
      t.boolean :primary_agency, :default => false, :null => false
      t.timestamps
    end

    add_index :agent_affiliations, [:agency_id, :agent_id],
      :name => "agency_id__agent_id", :unique => true
    add_index :agent_affiliations, [:agent_id, :agency_id],
      :name => "agent_id__agency_id"

    create_table :barrios, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      # REMOVED - maybe needed in the future? - act as tree
      #t.integer "parent_id"
      #t.integer "children_count",               :default => 0,  :null => false

      # REDUNDANT - country_id is also in `markets` table, but kept here so
      # that queries aren't as deep and for indexing
      t.integer :country_id, :null => false
      
      t.integer :zone_id, :null => false
      t.integer :province_id, :null => false
      t.integer :market_id
      t.integer :canton_id
      t.string  :name, :null => false
      t.integer :position
      t.string   :cached_slug
      t.timestamps
    end

    add_index :barrios, [:country_id, :province_id, :name],
      :name => "country_id__province__id_name"
    add_index :barrios, [:country_id, :province_id, :position],
      :name => "country_id__province_id__position"
    add_index :barrios, [:country_id, :zone_id, :name],
      :name => "country_id__zone_id__name"
    add_index :barrios, [:country_id, :zone_id, :position],
      :name => "country_id__zone_id__position"
    add_index :barrios, [:country_id, :market_id, :name],
      :name => "country_id__market_id__name", :unique => true
    add_index :barrios, [:country_id, :market_id, :position],
      :name => "country_id__market_id__position"
    add_index :barrios, [:country_id, :canton_id, :name],
      :name => "country_id__canton_id__name", :unique => true
    add_index :barrios, [:country_id, :canton_id, :position],
      :name => "country_id__canton_id__position"
    #add_index "barrios", ["parent_id"], :name => "parent_id"
    add_index :barrios, [:cached_slug], :name => "cached_slug"
    
    create_table :cantons, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
    :force => true do |t|

      # REDUNDANT - country_id is also in `markets` table, but kept here so
      # that queries aren't as deep and for indexing
      t.integer :country_id, :null => false
      
      t.integer :province_id, :null => false
      t.string  :name, :null => false
      t.integer :position
      t.string   :cached_slug
    end

    add_index :cantons, [:country_id, :province_id, :position],
      :name => "country_id__province_id__position"
    add_index :cantons, [:country_id, :province_id, :name], :name => "country_id__province_id__name", :unique => true
    add_index :cantons, [:cached_slug], :name => "cached_slug"

    create_table :categories, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      t.string   :name, :null => false
      t.boolean  :user_defined, :default => false, :null => false
      t.integer  :position
      t.string   :cached_slug
      t.timestamps
    end

    add_index :categories, [:name], :name => "name", :unique => true
    add_index :categories, [:position], :name => "position"
    add_index :categories, [:cached_slug], :name => "cached_slug"

    create_table :category_assignments,
      :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      t.integer :category_id, :null => false
      t.boolean  :primary_category, :default => false, :null => false
      # Polymorphic fields
      t.references :category_assignable, :polymorphic => true
      t.timestamps
    end
    
    add_index :category_assignments,
      [:category_assignable_type, :category_assignable_id, :category_id],
      :name => "category_assignable__category_id", :unique => true

    create_table :countries, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      t.string  :iso2, :limit => 2, :null => false
      t.string  :name, :null => false
      t.integer :position
      t.string   :cached_slug
      t.timestamps
    end

    add_index :countries, [:iso2], :name => "iso2", :unique => true
    add_index :countries, [:name], :name => "name", :unique => true
    add_index :countries, [:position], :name => "position"
    add_index :countries, [:cached_slug], :name => "cached_slug"

    create_table :currencies, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      t.string  :name, :null => false
      t.string  :code, :limit => 3, :null => false
      t.string  :symbol, :limit => 2, :null => false
      t.integer :position
      t.timestamps
    end

    add_index :currencies, [:code], :name => "code", :unique => true
    add_index :currencies, [:name], :name => "name", :unique => true
    add_index :currencies, [:symbol], :name => "symbol"
    add_index :currencies, [:position], :name => "position"

    create_table :features, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      t.string  :name, :null => false
      t.boolean :user_defined, :default => false, :null => false
      t.integer :position
      t.string   :cached_slug
      t.timestamps
    end

    add_index :features, [:name], :name => "name", :unique => true
    add_index :features, [:position], :name => "position"
    add_index :features, [:cached_slug], :name => "cached_slug"

    create_table :feature_assignments,
      :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer :feature_id, :null => false
      t.boolean  :highlighted_feature, :default => false, :null => false
      # Polymorphic fields
      t.references :feature_assignable, :polymorphic => true
      t.timestamps
    end

    add_index :feature_assignments,
      [:feature_assignable_type, :feature_assignable_id, :feature_id],
      :name => "feature_assignable__feature_id", :unique => true

    create_table :images, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      
      # Single-table inheritence
      t.string  :type,     :limit => 32,  :default => "", :null => false
      
      # Auto-magic fields for Fleximage plugin
      t.string   :image_filename
      t.integer  :image_width
      t.integer  :image_height
      
      t.string   :caption
      t.integer  :position
      t.boolean  :visible,                   :default => true, :null => false
      
      # Polymorphic fields
      t.references :imageable, :polymorphic => true
      t.timestamps
    end

    add_index :images, [:type, :imageable_type, :imageable_id, :position],
      :name => "type__imageable_type__imageable_id__position"

    create_table :information_requests,
      :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.string   :recipient_name
      t.string   :recipient_email
      t.integer  :user_id
      t.string   :name
      t.string   :email
      t.string   :phone
      t.text     :message
      
      # Polymorphic fields
      t.references :information_requestable, :polymorphic => true
      t.timestamps
    end

    add_index :information_requests, [:recipient_email],
      :name => "recipient_email"
    add_index :information_requests,
      [:information_requestable_type, :information_requestable_id],
      :name => "information_requestable"
    add_index :information_requests, [:user_id], :name => "user_id"
    add_index :information_requests, [:name], :name => "name"
    add_index :information_requests, [:email], :name => "email"
    add_index :information_requests, [:phone], :name => "phone"
    add_index :information_requests, [:created_at], :name => "created_at"

    create_table :listing_types,
      :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.string :name, :null => false
      t.string :cached_slug
      t.integer :position
      t.timestamps
    end

    add_index :listing_types, [:name], :name => "name", :unique => true
    add_index :listing_types, [:cached_slug], :name => "cached_slug"
    add_index :listing_types, [:position], :name => "position"

    create_table :listings, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      t.integer  :listing_type_id, :null => false
      t.integer  :property_id, :null => false
      t.string   :label, :null => false
      t.string   :name, :null => false
      t.text     :description
      t.integer  :ask_amount
      t.integer  :ask_currency_id
      t.integer  :close_amount
      t.integer  :close_currency_id
      t.date     :publish_date
      t.date     :date_available
      t.boolean  :show_agent, :default => true,  :null => false
      t.boolean  :show_agency, :default => true,  :null => false
      t.text     :admin_notes
      t.boolean  :sold, :default => false, :null => false
      t.boolean  :approved, :default => false, :null => false
      t.string   :cached_slug
      t.timestamps
    end

    add_index :listings, [:name], :name => "name"
    add_index :listings, [:date_available], :name => "date_available"
    add_index :listings, [:publish_date], :name => "publish_date"
    add_index :listings, [:listing_type_id, :property_id],
      :name => "listing_type_id"
    add_index :listings, [:property_id, :label],
      :name => "property_id__label", :unique => true
    add_index :listings, [:property_id, :name],
      :name => "property_id__name", :unique => true
    add_index :listings, [:cached_slug], :name => "cached_slug"

    # Markets are arbitrarily designated the administrator. They consist of
    # groups of barrios. They are not associated with zones, or
    # provinces because they could potentially overlap these borders
    create_table :markets, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      t.string  :name, :null => false
      
      # REDUNDANT - country_id is also in `barrios` table, but kept here for
      # indexing purposes
      t.integer  :country_id, :null => false
      
      t.integer :position
      t.text     :description
      t.text     :news
      t.string   :cached_slug
      t.timestamps
    end

    add_index :markets, [:country_id, :name], :name => "country_id__name",
      :unique => true
    add_index :markets, [:country_id, :position],
      :name => "country_id__position"
    add_index :markets, [:cached_slug], :name => "cached_slug"

    create_table :properties, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      t.string   :name, :null => false
      t.text     :description
      t.integer  :agency_id
      t.integer  :barrio_id
      t.integer  :bedroom_number, :limit => 3
      t.decimal  :bathroom_number, :precision => 3, :scale => 1
      t.integer  :construction_size
      t.integer  :land_size
      t.integer  :garage_spaces, :limit => 2
      t.integer  :parking_spaces, :limit => 3
      t.integer  :year_built
      t.integer  :stories, :limit => 2
      t.date     :date_available
      t.timestamps
    end
    
    add_index :properties, [:agency_id], :name => "agency_id"
    add_index :properties, [:barrio_id], :name => "barrio_id"

    create_table :market_segments,
      :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      t.string  :name, :limit => 64, :default => "", :null => false
      t.integer :position
      t.string   :cached_slug
      t.timestamps
    end

    add_index :market_segments, [:name], :name => "name", :unique => true
    add_index :market_segments, [:position], :name => "position"
    add_index :market_segments, [:cached_slug], :name => "cached_slug"

    create_table :provinces, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      t.integer :country_id, :null => false
      t.string  :name, :null => false
      t.integer :position
      t.string  :cached_slug
      t.timestamps
    end

    add_index :provinces, [:country_id, :name], :name => "country_id__name",
      :unique => true
    add_index :provinces, [:country_id, :position],
      :name => "country_id__position"
    add_index :provinces, [:cached_slug], :name => "cached_slug"
    
    create_table :site_texts,
      :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer :agency_id, :null => false
      t.string :name, :null => false
      t.text :value
      t.timestamps
    end
    
    add_index :site_texts, [:agency_id, :name], :name => "agency_id__name"

    create_table :styles, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      t.string  :name, :null => false
      t.boolean :user_defined, :default => false, :null => false
      t.integer :position
      t.string  :cached_slug
      t.timestamps
    end

    add_index :styles, [:name], :name => "name", :unique => true
    add_index :styles, [:position], :name => "position"
    add_index :styles, [:cached_slug], :name => "cached_slug"

    create_table :style_assignments,
      :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer    :style_id, :null => false
      t.boolean    :primary_style, :default => false, :null => false
      
      # Polymorphic fields
      t.references :style_assignable, :polymorphic => true
      
      t.timestamps
    end

    add_index :style_assignments,
      [:style_assignable_type, :style_assignable_id, :style_id],
      :name => "style_assignable__style_id", :unique => true

    create_table :users, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
    
      t.integer :nationality_id
      t.string :first_name
      t.string :last_name
      t.string :second_last_name
      t.string :middle_name
      t.string :mobile_phone
      t.string :work_phone
      t.string :home_phone
      t.string :fax
      t.string :address_1
      t.string :address_2
      t.string :job_title
      t.text   :referer_url
      t.string :cached_slug
      
      # Authentication fields needed for AuthLogic plugin
      # See documentation at http://authlogic.rubyforge.org/
      #
      t.string    :email
      # optional, you can use email instead, or both
      t.string    :login,               :null => false
      # optional, see below
      t.string    :crypted_password,    :null => false
      # optional, but highly recommended
      t.string    :password_salt,       :null => false
      # required
      t.string    :persistence_token,   :null => false
      # optional, see Authlogic::Session::Params
      t.string    :single_access_token, :null => false
      # optional, see Authlogic::Session::Perishability
      t.string    :perishable_token,    :null => false
      # optional, see Authlogic::Session::MagicColumns
      t.integer   :login_count,         :null => false, :default => 0
      t.integer   :failed_login_count,  :null => false, :default => 0
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip
      
      t.timestamps
    end
    
    add_index :users, [:email], :name => 'email', :unique => true
    add_index :users, [:login], :name => 'login', :unique => true
    add_index :users, [:last_name, :first_name],
      :name => 'last_name__first_name'
    add_index :users, [:first_name, :last_name],
      :name => 'first_name__last_name'
    add_index :users, [:mobile_phone], :name => 'mobile_phone'
    add_index :users, [:work_phone], :name => 'work_phone'
    add_index :users, [:home_phone], :name => 'home_phone'
    add_index :users, [:cached_slug], :name => "cached_slug"
    
    add_index :users, [:persistence_token], :name => "persistence_token"
    add_index :users, [:last_request_at], :name => "last_request_at"

    create_table :zones, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8",
      :force => true do |t|
      t.integer :country_id, :null => false
      t.string  :name, :null => false
      t.integer :position
      t.string  :cached_slug
      t.timestamps
    end
    
    add_index :zones, [:country_id, :name], :name => "country_id__name",
      :unique => true
    add_index :zones, [:country_id, :position],
      :name => "country_id__position"
    add_index :zones, [:cached_slug], :name => "cached_slug"
  end

  def self.down
    # should drop all tables here
    drop_table :agencies
    drop_table :agency_jurisdictions
    drop_table :agency_relationships
    drop_table :agents
    drop_table :agent_affiliations
    drop_table :barrios
    drop_table :cantons
    drop_table :categories
    drop_table :category_assignments
    drop_table :site_texts
    drop_table :countries
    drop_table :currencies
    drop_table :features
    drop_table :feature_assignments
    drop_table :images
    drop_table :information_requests
    drop_table :listing_types
    drop_table :listings
    drop_table :markets
    drop_table :users
    drop_table :properties
    drop_table :provinces
    drop_table :styles
    drop_table :style_assignments
    drop_table :zones
  end
end

