# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090630115317) do

  create_table "agencies", :force => true do |t|
    t.integer  "country_id"
    t.integer  "broker_id"
    t.integer  "market_segment_id"
    t.string   "name",                                 :null => false
    t.string   "short_name",                           :null => false
    t.string   "domain"
    t.string   "subdomain"
    t.string   "email"
    t.string   "skype"
    t.text     "description"
    t.boolean  "master_agency",     :default => false, :null => false
    t.integer  "position"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agencies", ["cached_slug"], :name => "cached_slug"
  add_index "agencies", ["country_id", "position"], :name => "country_id__position"
  add_index "agencies", ["domain", "subdomain"], :name => "domain__subdomain", :unique => true
  add_index "agencies", ["name"], :name => "name", :unique => true
  add_index "agencies", ["short_name"], :name => "short_name", :unique => true

  create_table "agency_jurisdictions", :force => true do |t|
    t.integer  "market_id",                         :null => false
    t.integer  "agency_id",                         :null => false
    t.boolean  "primary_market", :default => false, :null => false
    t.boolean  "primary_agency", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agency_jurisdictions", ["agency_id", "market_id"], :name => "agency_id__market_id", :unique => true
  add_index "agency_jurisdictions", ["market_id", "agency_id"], :name => "market_id__agency_id"

  create_table "agency_relationships", :force => true do |t|
    t.integer  "agency_id",  :null => false
    t.integer  "partner_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agency_relationships", ["agency_id", "partner_id"], :name => "agency_id__partner_id", :unique => true

  create_table "agent_affiliations", :force => true do |t|
    t.integer  "agency_id",                         :null => false
    t.integer  "agent_id",                          :null => false
    t.boolean  "primary_agency", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agent_affiliations", ["agency_id", "agent_id"], :name => "agency_id__agent_id", :unique => true
  add_index "agent_affiliations", ["agent_id", "agency_id"], :name => "agent_id__agency_id"

  create_table "agents", :force => true do |t|
    t.integer  "user_id",        :null => false
    t.text     "mini_biography"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agents", ["user_id"], :name => "user_id", :unique => true

  create_table "barrios", :force => true do |t|
    t.integer  "canton_id",   :null => false
    t.integer  "market_id"
    t.string   "name",        :null => false
    t.integer  "position"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "barrios", ["cached_slug"], :name => "cached_slug"
  add_index "barrios", ["canton_id", "name"], :name => "canton_id__name", :unique => true
  add_index "barrios", ["canton_id", "position"], :name => "canton_id__position"
  add_index "barrios", ["market_id", "name"], :name => "market_id__name", :unique => true
  add_index "barrios", ["market_id", "position"], :name => "market_id__position"

  create_table "cantons", :force => true do |t|
    t.integer "province_id", :null => false
    t.integer "zone_id",     :null => false
    t.string  "name",        :null => false
    t.integer "position"
    t.string  "cached_slug"
  end

  add_index "cantons", ["cached_slug"], :name => "cached_slug"
  add_index "cantons", ["province_id", "name"], :name => "province_id__name", :unique => true
  add_index "cantons", ["province_id", "position"], :name => "province_id__position"
  add_index "cantons", ["zone_id", "name"], :name => "zone_id__name", :unique => true
  add_index "cantons", ["zone_id", "position"], :name => "zone_id__position"

  create_table "categories", :force => true do |t|
    t.string   "name",                            :null => false
    t.boolean  "user_defined", :default => false, :null => false
    t.integer  "position"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["cached_slug"], :name => "cached_slug"
  add_index "categories", ["name"], :name => "name", :unique => true
  add_index "categories", ["position"], :name => "position"

  create_table "category_assignments", :force => true do |t|
    t.integer  "category_id",                                 :null => false
    t.boolean  "primary_category",         :default => false, :null => false
    t.integer  "category_assignable_id"
    t.string   "category_assignable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_assignments", ["category_assignable_type", "category_assignable_id", "category_id"], :name => "category_assignable__category_id", :unique => true

  create_table "countries", :force => true do |t|
    t.string   "iso2",        :limit => 2, :null => false
    t.string   "name",                     :null => false
    t.integer  "currency_id"
    t.integer  "position"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["cached_slug"], :name => "cached_slug"
  add_index "countries", ["iso2"], :name => "iso2", :unique => true
  add_index "countries", ["name"], :name => "name", :unique => true
  add_index "countries", ["position"], :name => "position"

  create_table "currencies", :force => true do |t|
    t.string   "name",                    :null => false
    t.string   "code",       :limit => 3, :null => false
    t.string   "symbol",     :limit => 2, :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "currencies", ["code"], :name => "code", :unique => true
  add_index "currencies", ["name"], :name => "name", :unique => true
  add_index "currencies", ["position"], :name => "position"
  add_index "currencies", ["symbol"], :name => "symbol"

  create_table "feature_assignments", :force => true do |t|
    t.integer  "feature_id",                                 :null => false
    t.boolean  "highlighted_feature",     :default => false, :null => false
    t.integer  "feature_assignable_id"
    t.string   "feature_assignable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feature_assignments", ["feature_assignable_type", "feature_assignable_id", "feature_id"], :name => "feature_assignable__feature_id", :unique => true

  create_table "features", :force => true do |t|
    t.string   "name",                            :null => false
    t.boolean  "user_defined", :default => false, :null => false
    t.integer  "position"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "features", ["cached_slug"], :name => "cached_slug"
  add_index "features", ["name"], :name => "name", :unique => true
  add_index "features", ["position"], :name => "position"

  create_table "images", :force => true do |t|
    t.string   "type",           :limit => 32, :default => "",   :null => false
    t.string   "image_filename"
    t.integer  "image_width"
    t.integer  "image_height"
    t.string   "caption"
    t.integer  "position"
    t.boolean  "visible",                      :default => true, :null => false
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["type", "imageable_type", "imageable_id", "position"], :name => "type__imageable_type__imageable_id__position"

  create_table "information_requests", :force => true do |t|
    t.string   "recipient_name"
    t.string   "recipient_email"
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "message"
    t.integer  "information_requestable_id"
    t.string   "information_requestable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "information_requests", ["created_at"], :name => "created_at"
  add_index "information_requests", ["email"], :name => "email"
  add_index "information_requests", ["information_requestable_type", "information_requestable_id"], :name => "information_requestable"
  add_index "information_requests", ["name"], :name => "name"
  add_index "information_requests", ["phone"], :name => "phone"
  add_index "information_requests", ["recipient_email"], :name => "recipient_email"
  add_index "information_requests", ["user_id"], :name => "user_id"

  create_table "listing_types", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "cached_slug"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "listing_types", ["cached_slug"], :name => "cached_slug"
  add_index "listing_types", ["name"], :name => "name", :unique => true
  add_index "listing_types", ["position"], :name => "position"

  create_table "listings", :force => true do |t|
    t.integer  "listing_type_id",                      :null => false
    t.integer  "property_id",                          :null => false
    t.string   "label",                                :null => false
    t.string   "name",                                 :null => false
    t.text     "description"
    t.integer  "ask_amount"
    t.integer  "ask_currency_id"
    t.integer  "close_amount"
    t.integer  "close_currency_id"
    t.date     "publish_date"
    t.date     "date_available"
    t.boolean  "show_agent",        :default => true,  :null => false
    t.boolean  "show_agency",       :default => true,  :null => false
    t.text     "admin_notes"
    t.boolean  "sold",              :default => false, :null => false
    t.boolean  "approved",          :default => false, :null => false
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "listings", ["cached_slug"], :name => "cached_slug"
  add_index "listings", ["date_available"], :name => "date_available"
  add_index "listings", ["listing_type_id", "property_id"], :name => "listing_type_id"
  add_index "listings", ["name"], :name => "name"
  add_index "listings", ["property_id", "label"], :name => "property_id__label", :unique => true
  add_index "listings", ["property_id", "name"], :name => "property_id__name", :unique => true
  add_index "listings", ["publish_date"], :name => "publish_date"

  create_table "market_segments", :force => true do |t|
    t.string   "name",        :limit => 64, :default => "", :null => false
    t.integer  "position"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "market_segments", ["cached_slug"], :name => "cached_slug"
  add_index "market_segments", ["name"], :name => "name", :unique => true
  add_index "market_segments", ["position"], :name => "position"

  create_table "markets", :force => true do |t|
    t.string   "name",        :null => false
    t.integer  "country_id",  :null => false
    t.integer  "position"
    t.text     "description"
    t.text     "news"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "markets", ["cached_slug"], :name => "cached_slug"
  add_index "markets", ["country_id", "name"], :name => "country_id__name", :unique => true
  add_index "markets", ["country_id", "position"], :name => "country_id__position"

  create_table "properties", :force => true do |t|
    t.string   "name",                                                         :null => false
    t.integer  "agency_id"
    t.integer  "barrio_id",                                                    :null => false
    t.integer  "bedroom_number",    :limit => 3
    t.decimal  "bathroom_number",                :precision => 3, :scale => 1
    t.integer  "construction_size"
    t.integer  "land_size"
    t.integer  "garage_spaces",     :limit => 2
    t.integer  "parking_spaces",    :limit => 3
    t.integer  "year_built"
    t.integer  "stories",           :limit => 2
    t.date     "date_available"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "properties", ["agency_id"], :name => "agency_id"
  add_index "properties", ["barrio_id"], :name => "barrio_id"

  create_table "provinces", :force => true do |t|
    t.integer  "country_id",  :null => false
    t.string   "name",        :null => false
    t.integer  "position"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provinces", ["cached_slug"], :name => "cached_slug"
  add_index "provinces", ["country_id", "name"], :name => "country_id__name", :unique => true
  add_index "provinces", ["country_id", "position"], :name => "country_id__position"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "site_texts", :force => true do |t|
    t.integer  "agency_id",  :null => false
    t.string   "name",       :null => false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "site_texts", ["agency_id", "name"], :name => "agency_id__name"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "style_assignments", :force => true do |t|
    t.integer  "style_id",                                 :null => false
    t.boolean  "primary_style",         :default => false, :null => false
    t.integer  "style_assignable_id"
    t.string   "style_assignable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "style_assignments", ["style_assignable_type", "style_assignable_id", "style_id"], :name => "style_assignable__style_id", :unique => true

  create_table "styles", :force => true do |t|
    t.string   "name",                            :null => false
    t.boolean  "user_defined", :default => false, :null => false
    t.integer  "position"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "styles", ["cached_slug"], :name => "cached_slug"
  add_index "styles", ["name"], :name => "name", :unique => true
  add_index "styles", ["position"], :name => "position"

  create_table "users", :force => true do |t|
    t.integer  "nationality_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "second_last_name"
    t.string   "middle_name"
    t.string   "mobile_phone"
    t.string   "work_phone"
    t.string   "home_phone"
    t.string   "fax"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "job_title"
    t.text     "referer_url"
    t.string   "cached_slug"
    t.string   "email"
    t.string   "login",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["cached_slug"], :name => "cached_slug"
  add_index "users", ["email"], :name => "email", :unique => true
  add_index "users", ["first_name", "last_name"], :name => "first_name__last_name"
  add_index "users", ["home_phone"], :name => "home_phone"
  add_index "users", ["last_name", "first_name"], :name => "last_name__first_name"
  add_index "users", ["last_request_at"], :name => "last_request_at"
  add_index "users", ["login"], :name => "login", :unique => true
  add_index "users", ["mobile_phone"], :name => "mobile_phone"
  add_index "users", ["persistence_token"], :name => "persistence_token"
  add_index "users", ["work_phone"], :name => "work_phone"

  create_table "zones", :force => true do |t|
    t.integer  "country_id",  :null => false
    t.string   "name",        :null => false
    t.integer  "position"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zones", ["cached_slug"], :name => "cached_slug"
  add_index "zones", ["country_id", "name"], :name => "country_id__name", :unique => true
  add_index "zones", ["country_id", "position"], :name => "country_id__position"

end
