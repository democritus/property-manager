class CreateDatabaseFromSchema < ActiveRecord::Migration
  def self.up

# Not sure if administrator-related tables will be used
#    create_table "administrators", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
#      t.integer  "user_id",                      :default => 0,  :null => false
#      t.timestamps
#    end

#    add_index "administrators", ["user_id"], :name => "user_id", :unique => true

#    create_table "administrator_jurisdictions", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
#      t.integer "market_id",                     :default => 0, :null => false
#      t.integer "administrator_id",              :null => false
#      t.boolean "primary_market",                   :default => false, :null => false
#      t.timestamps
#    end

#    add_index "administrator_jurisdictions", ["administrator_id", "market_id"], :name => "administrator_id", :unique => true
#    add_index "administrator_jurisdictions", ["market_id", "administrator_id"], :name => "market_id"

    create_table "agencies", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      # TODO: if agencies need to be associated with multiple countries,
      # a new lookup table will need to be created. Note that this country
      # is only used to facilitate associating markets and should not be
      # used to constrain listing results globally
      t.integer  "country_id",                                        :null => false
      t.string   "name",        :limit => 64,                         :null => false
      t.string   "short_name",        :limit => 32,                   :null => false
      t.string   "domain",        :limit => 64,                       :null => false
      t.string   "subdomain",       :limit => 64,                     :null => false
      t.string   "email",       :limit => 128
      t.string   "skype",       :limit => 64
      t.integer  "broker_id"
      t.text     "description"
      t.boolean  "master_agency",                   :default => false, :null => false
      t.timestamps
    end

    add_index "agencies", ["name"], :name => "name", :unique => true
    add_index "agencies", ["short_name"], :name => "short_name", :unique => true
    add_index "agencies", ["domain", "subdomain"], :name => "domain__subdomain", :unique => true

    create_table "agency_jurisdictions", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer "market_id",                          :default => 0, :null => false
      t.integer "agency_id",                                          :null => false
      t.boolean "primary_market",                   :default => false, :null => false
      t.boolean "primary_agency",                   :default => false, :null => false
      t.timestamps
    end

    add_index "agency_jurisdictions", ["agency_id", "market_id"], :name => "agency_id__market_id", :unique => true
    add_index "agency_jurisdictions", ["market_id", "agency_id"], :name => "market_id__agency_id"
    
    create_table "agency_relationships", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer "agency_id",                          :default => 0, :null => false
      t.integer "partner_id",                                          :null => false
      t.timestamps
    end

    add_index "agency_relationships", ["agency_id", "partner_id"], :name => "agency_id__partner_id", :unique => true

    create_table "agents", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer  "user_id",                                      :null => false
      t.text     "mini_biography"
      t.timestamps
    end

    add_index "agents", ["user_id"], :name => "user_id", :unique => true

    create_table "agent_affiliations", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer "agency_id",                          :default => 0, :null => false
      t.integer "agent_id",                                           :null => false
      t.boolean "primary_agency",                   :default => false, :null => false
      #MOVED TO `agencies`
      #t.boolean "broker",                   :default => false, :null => false
      t.timestamps
    end

    add_index "agent_affiliations", ["agency_id", "agent_id"], :name => "agency_id__agent_id", :unique => true
    add_index "agent_affiliations", ["agent_id", "agency_id"], :name => "agent_id__agency_id"

    create_table "barrios", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      # REMOVED - maybe needed in the future? - act as tree
      #t.integer "parent_id"
      #t.integer "children_count",               :default => 0,  :null => false

      t.integer "market_id"
      
      # REDUNDANT - country_id is also in `markets` table, but kept here so
      # that queries aren't as deep and for indexing
      t.integer "country_id", :null => false
      
      t.integer "zone_id", :null => false
      t.integer "province_id", :null => false
      t.string  "name",           :limit => 50, :default => "", :null => false
      t.integer "position"
      t.timestamps
    end

    add_index "barrios", ["country_id", "province_id", "name"], :name => "country_id__province__id_name"
    add_index "barrios", ["country_id", "zone_id", "name"], :name => "country_id__zone_id__name"
    add_index "barrios", ["country_id", "market_id", "name"], :name => "country_id__market_id__name", :unique => true
    add_index "barrios", ["country_id", "market_id", "position"], :name => "country_id__market_id__position"
    #add_index "barrios", ["parent_id"], :name => "parent_id"

    create_table "categories", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.string  "name",            :limit => 64, :default => "",     :null => false
      t.boolean  "user_defined",                   :default => false, :null => false
      t.integer "position"
      t.timestamps
    end

    add_index "categories", ["name"], :name => "name", :unique => true

    create_table "category_assignments", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer "category_id",              :null => false
      t.boolean  "primary_category",                   :default => false, :null => false
      # Polymorphic fields
      t.references :category_assignable, :polymorphic => true
      t.timestamps
    end

    create_table "countries", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.string  "iso2",     :limit => 2,   :default => "", :null => false
      t.string  "name",     :limit => 128, :default => "", :null => false
      t.integer "position"
      t.timestamps
    end

    add_index "countries", ["iso2"], :name => "iso2", :unique => true
    add_index "countries", ["name"], :name => "name", :unique => true
    add_index "countries", ["position"], :name => "position"

    create_table "currencies", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.string  "name",     :limit => 128, :default => "", :null => false
      t.string  "code",     :limit => 3,   :default => "", :null => false
      t.string  "symbol",     :limit => 2,   :default => "", :null => false
      t.integer "position"
      t.timestamps
    end

    add_index "currencies", ["code"], :name => "code", :unique => true
    add_index "currencies", ["name"], :name => "name", :unique => true

    create_table "features", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.string  "name",            :limit => 64, :default => "",     :null => false
      t.boolean  "user_defined",                   :default => false, :null => false
      t.integer "position"
      t.timestamps
    end

    add_index "features", ["name"], :name => "name", :unique => true

    create_table "feature_assignments", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer "feature_id",              :null => false
      t.boolean  "highlighted_feature",                   :default => false, :null => false
      # Polymorphic fields
      t.references :feature_assignable, :polymorphic => true
      t.timestamps
    end

    add_index "feature_assignments", ["feature_assignable_type", "feature_assignable_id", "feature_id"], :name => "feature_assignable__feature_id", :unique => true

    create_table "images", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      # Single-table inheritence
      t.string  "type",     :limit => 32,  :default => "", :null => false
      
      # Auto-magic fields for Fleximage plugin
      t.string   "image_filename"
      t.integer  "image_width"
      t.integer  "image_height"
      
      t.string   "caption"
      t.integer  "position"
      t.boolean  "visible",                   :default => true, :null => false
      
      # Polymorphic fields
      t.references :imageable, :polymorphic => true
      t.timestamps
    end

    add_index "images", ["imageable_type", "imageable_id", "position"], :name => "imageable__position"

    create_table "information_requests", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.string   "recipient_name",      :limit => 64
      t.string   "recipient_email",      :limit => 128
      t.integer  "user_id"
      t.string   "name",       :limit => 64
      t.string   "email",      :limit => 128
      t.string   "phone",      :limit => 20
      t.text     "message"
      
      # Polymorphic fields
      t.references :information_requestable, :polymorphic => true
      t.timestamps
    end

    add_index "information_requests", ["recipient_email"], :name => "recipient_email"
    add_index "information_requests", ["information_requestable_type", "information_requestable_id"], :name => "information_requestable"
    add_index "information_requests", ["user_id"], :name => "user_id"
    add_index "information_requests", ["name"], :name => "name"
    add_index "information_requests", ["email"], :name => "email"
    add_index "information_requests", ["phone"], :name => "phone"
    add_index "information_requests", ["created_at"], :name => "created_at"

    create_table "listing_types", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.string "name", :limit => 20, :default => "", :null => false
      t.timestamps
    end

    add_index "listing_types", ["name"], :name => "name", :unique => true

    create_table "listings", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer "listing_type_id", :default => 1, :null => false
      t.integer  "property_id",                                               :null => false
      t.string   "label",                     :limit => 64, :default => "",    :null => false
      t.string   "name",                     :limit => 64,                     :null => false
      t.text     "description"
#      t.integer  "agency_id"
      t.integer  "ask_amount"
      t.integer  "ask_currency_id",                         :default => 1
      t.integer  "close_amount"
      t.integer  "close_currency_id",                       :default => 1
      t.date     "publish_date"
      t.date     "listing_expiration_date"
      t.date     "contract_expiration_date"
      t.date     "date_available"
      t.boolean  "show_agent",                        :default => true,  :null => false
      t.boolean  "show_agency",                       :default => true,  :null => false
      t.text     "admin_notes"
      t.boolean  "sold",                              :default => false, :null => false
      t.boolean  "approved",                          :default => false, :null => false
      t.timestamps
    end

#    add_index "listings", ["agency_id"], :name => "agency_id"
    add_index "listings", ["name"], :name => "name"
    add_index "listings", ["date_available"], :name => "date_available"
    add_index "listings", ["contract_expiration_date"], :name => "contract_expiration_date"
    add_index "listings", ["listing_expiration_date"], :name => "listing_expiration_date"
    add_index "listings", ["publish_date"], :name => "publish_date"
    add_index "listings", ["listing_type_id", "property_id"], :name => "listing_type_id"
    add_index "listings", ["property_id", "label"], :name => "property_id__label", :unique => true
    add_index "listings", ["property_id", "name"], :name => "property_id__name", :unique => true

    # Markets are arbitrarily designated the administrator. They consist of
    # groups of barrios. They are not associated with zones, or
    # provinces because they could potentially overlap these borders
    create_table "markets", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.string  "name",        :limit => 50, :default => "", :null => false
      
      # REDUNDANT - country_id is also in `barrios` table, but kept here for
      # indexing purposes
      t.integer  "country_id",                               :null => false
      
      t.integer "position"
      t.text     "description"
      t.text     "news"
      t.timestamps
    end

    add_index "markets", ["country_id", "name"], :name => "country_id__name", :unique => true
    add_index "markets", ["name"], :name => "name"

    create_table "properties", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.string   "name",              :limit => 64,                               :default => "", :null => false
      t.text     "description"
      t.integer  "agency_id"
      t.integer  "barrio_id",                                                                     :null => false
      t.integer  "bedroom_number",    :limit => 2
      t.decimal  "bathroom_number",                 :precision => 3, :scale => 1
      t.integer  "construction_size"
      t.integer  "land_size"
      t.integer  "garage_spaces",    :limit => 2
      t.integer  "parking_spaces",    :limit => 2
      t.integer  "year_built"
      t.integer  "stories",           :limit => 2
      t.date     "date_available"
      t.timestamps
    end
    
    add_index "properties", ["agency_id"], :name => "agency_id"
    add_index "properties", ["barrio_id"], :name => "barrio_id"

    create_table "provinces", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer "country_id",                               :null => false
      t.string  "name",       :limit => 50, :default => "", :null => false
      t.integer "position"
      t.timestamps
    end

    add_index "provinces", ["country_id", "name"], :name => "country_id__name", :unique => true
    add_index "provinces", ["country_id", "position", "name"], :name => "country_id__position__name"
    add_index "provinces", ["name"], :name => "name"

    add_index "category_assignments", ["category_assignable_type", "category_assignable_id", "category_id"], :name => "category_assignable__category_id", :unique => true
    
    create_table :site_texts, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer :agency_id, :null => false
      t.string :name, :limit => 64, :default => "", :null => false
      t.text :value
      t.timestamps
    end
    
    add_index :site_texts, [:agency_id, :name], :name => "agency_id__name"

    create_table "styles", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.string  "name",            :limit => 64, :default => "",     :null => false
      t.boolean  "user_defined",                   :default => false, :null => false
      t.integer "position"
      t.timestamps
    end

    add_index "styles", ["name"], :name => "name", :unique => true

    create_table "style_assignments", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer "style_id",              :null => false
      t.boolean  "primary_style",                   :default => false, :null => false
      # Polymorphic fields
      t.references :style_assignable, :polymorphic => true
      t.timestamps
    end

    add_index "style_assignments", ["style_assignable_type", "style_assignable_id", "style_id"], :name => "style_assignable__style_id", :unique => true

    create_table "users", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      # Copied from AuthLogic plugin: http://authlogic.rubyforge.org/
      t.string    :login,               :null => false                # optional, you can use email instead, or both
      t.string    :crypted_password,    :null => false                # optional, see below
      t.string    :password_salt,       :null => false                # optional, but highly recommended
      t.string    :persistence_token,   :null => false                # required
      t.string    :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.string    :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability
      t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
      t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
      t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
      t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns

      t.string   "first_name",                  :limit => 32
      t.string   "last_name",                   :limit => 32
      t.string   "sex",                         :limit => 1
      t.integer  "nationality_id"
      t.string   "email",                       :limit => 128
      t.string   "email_public",                :limit => 128
      t.string   "phone_home",                  :limit => 32
      t.string   "phone_work",                  :limit => 32
      t.string   "phone_mobile",                :limit => 32
      t.string   "phone_fax",                   :limit => 32
      t.string   "address1",                    :limit => 128
      t.string   "address2",                    :limit => 128
      t.string   "postal_code",                 :limit => 16
      t.text     "original_referer_url"

      t.datetime "date_verified"
      t.timestamps
    end

    add_index "users", ["email"], :name => "email", :unique => true
    add_index "users", ["login"], :name => "login", :unique => true
    add_index "users", ["persistence_token"], :name => "persistence_token"
    add_index "users", ["last_request_at"], :name => "last_request_at"

    create_table "zones", :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8", :force => true do |t|
      t.integer "country_id",                               :null => false
      t.string  "name",       :limit => 50, :default => "", :null => false
      t.integer "position"
      t.timestamps
    end
    
    add_index "zones", ["country_id", "name"], :name => "country_id__name", :unique => true
    add_index "zones", ["country_id", "position", "name"], :name => "country_id__position__name"
    add_index "zones", ["name"], :name => "name"
  end

  def self.down
    # should drop all tables here
#    drop_table "administrators"
#    drop_table "administrator_jurisdictions"
    drop_table "agencies"
    drop_table "agency_jurisdictions"
    drop_table "agency_relationships"
    drop_table "agents"
    drop_table "agent_affiliations"
    drop_table "barrios"
    drop_table "categories"
    drop_table "category_assignments"
    drop_table :site_texts
    drop_table "countries"
    drop_table "currencies"
    drop_table "features"
    drop_table "feature_assignments"
    drop_table "images"
    drop_table "information_requests"
    drop_table "listing_types"
    drop_table "listings"
    drop_table "markets"
    drop_table "users"
    drop_table "properties"
    drop_table "provinces"
    drop_table "styles"
    drop_table "style_assignments"
    drop_table "zones"
  end
end

