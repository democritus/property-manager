class AddTestData < ActiveRecord::Migration
  def self.up


# Not sure if administrator-related tables will be used
#    Administrator.delete_all

#    Administrator.create(:user_id => 1
#    )
#    Administrator.create(:user_id => 2
#    )


#    AdministratorJurisdiction.delete_all

#    AdministratorJurisdiction.create(:market_id => 1,
#      :administrator_id => 1
#    )

#    AdministratorJurisdiction.create(:market_id => 1,
#      :administrator_id => 2
#    )


# Users and related data should be added via website
#    Agent.delete_all

#    Agent.create(:user_id => 1,
#      :mini_biography =>
#    %{Brian is cool}
#    )

#    Agent.create(:user_id => 2,
#      :mini_biography =>
#      %{Having lived and worked in Costa Rica for a number of years, Phil has developed a keen sense for finding properties that best match a client's lifestyle. Phil's practical, no-nonsense approach also helps his clients make clear, informed choices when qualifying candidate properties for investment.}
#    )


#    AgentAffiliation.delete_all

#    AgentAffiliation.create(:agent_id => 1,
#      :agency_id => 2
#    )

#    AgentAffiliation.create(:agent_id => 1,
#      :agency_id => 3
#    )

#    AgentAffiliation.create(:agent_id => 2,
#      :agency_id => 2
#    )

#    AgentAffiliation.create(:agent_id => 2,
#      :agency_id => 3
#    )


    Category.delete_all

    Category.create(:name => 'Homes',
      :user_defined => false
    )

    Category.create(:name => 'Condos',
      :user_defined => false
    )

    Category.create(:name => 'Apartments',
      :user_defined => false
    )

    Category.create(:name => 'Hotels',
      :user_defined => false
    )

    Category.create(:name => 'Tin Shacks',
      :user_defined => true
    )


    Country.delete_all

    Country.create(:name => 'United States',
      :iso2 => 'us'
      #:position =>
    )

    Country.create(:name => 'Costa Rica',
      :iso2 => 'cr'
      #:position =>
    )


#    Agency.delete_all
#
#    Agency.create(:name => 'BarrioEarth Real Estate',
#      :short_name => 'BarrioEarth',
#      :country_id => 2,
#      :domain => 'barrioearth.com',
#      :subdomain => nil,
#      :master_agency => true
#    )
#
#    Agency.create(:name => 'BarrioEarth Heredia',
#      :short_name => 'Heredia',
#      :country_id => 2,
#      :domain => 'barrioearth.com',
#      :subdomain => 'heredia'
#    )
#
#    Agency.create(:name => 'BarrioEarth Jacó',
#      :short_name => 'Jacó Beach',
#      :country_id => 2,
#      :domain => 'barrioearth.com',
#      :subdomain => 'jaco'
#    )


    Currency.delete_all

    Currency.create(:name => 'United States of America Dollars',
      :code => 'USD',
      :symbol => '$'
    )

    Currency.create(:name => 'Euros',
      :code => 'EUR',
      :symbol => '€'
    )


    Feature.delete_all

    Feature.create(:name => 'Hot water',
      :user_defined => false
    )

    Feature.create(:name => 'Balcony',
      :user_defined => false
    )

    Feature.create(:name => 'Pool',
      :user_defined => false
    )

    Feature.create(:name => 'Option to buy furniture',
      :user_defined => true
    )

    Feature.create(:name => 'Stainless steel appliances',
      :user_defined => true
    )

    Feature.create(:name => '$150 monthly maintenance fees',
      :user_defined => true
    )

    Feature.create(:name => 'Rancho',
      :user_defined => true
    )


    # REMOVED: better to test these manually
    #InformationRequest.delete_all
    #
    #InformationRequest.create(:listing_id => 1,
    #  :recipient_email => 'phemion@hotmail.com',
    #  #:user_id => ,
    #  :name => 'Visitor',
    #  :email => 'visitor@xyz.com',
    #  :phone => '2819703700',
    #  :message => 'test message'
    #)


    Property.delete_all

    Property.create(:name => 'Munster Mansion',
    :description =>
    %{Munster mansion is full of monsters!},
#    :agency_id => nil,
    :barrio_id => 1,
    :bedroom_number => 7,
    :bathroom_number => 3.5,
    :construction_size => 1000,
    :land_size => 4000,
    :parking_spaces => 6,
    :year_built => 1823,
    :stories => 3,
    :date_available => '2009-01-18')

    Property.create(:name => 'Heartbreak Hotel',
    :description =>
    %{Hubba hubba hubba. Elvis is in the house!},
#    :agency_id => nil,
    :barrio_id => 1,
    :bedroom_number => 42,
    :bathroom_number => 1.5,
    :construction_size => 7000,
    :land_size => 4000,
    :parking_spaces => 200,
    :year_built => 1955,
    :stories => 4,
    :date_available => '2009-05-22')

    Property.create(:name => 'Hotel California',
    :description =>
    %{You can check out, but you can never leave!},
#    :agency_id => nil,
    :barrio_id => 2,
    :bedroom_number => 20,
    :bathroom_number => 1,
    :construction_size => 3400,
    :land_size => 2350,
    :parking_spaces => 50,
    :year_built => 1972,
    :stories => 2,
    :date_available => '2009-07-04')


    ListingType.delete_all

    ListingType.create(:name => 'for sale'
    )

    ListingType.create(:name => 'for rent'
    )


    Market.delete_all
    Market.create(:name => 'Heredia',
      :country_id => 2
      #:position =>
    )
    Market.create(:name => 'Jacó Beach',
      :country_id => 2
      #:position =>
    )
    Market.create(:name => 'Montezuma Beach',
      :country_id => 2
      #:position =>
    )
    
    
    Zone.delete_all

    Zone.create(:country_id => 2,
      :name => 'North Pacific'
      #:position =>
    )

    Zone.create(:country_id => 2,
      :name => 'Central Pacific'
      #:position =>
    )

    Zone.create(:country_id => 2,
      :name => 'South Pacific'
      #:position =>
    )

    Zone.create(:country_id => 2,
      :name => 'Caribbean'
      #:position =>
    )

    Zone.create(:country_id => 2,
      :name => 'Central Valley'
      #:position =>
    )

    Zone.create(:country_id => 2,
      :name => 'Northern Plains'
      #:position =>
    )
    

    Province.delete_all

    Province.create(:country_id => 2,
      :name => 'Alajuela'
      #:position =>
    )

    Province.create(:country_id => 2,
      :name => 'Cartago'
      #:position =>
    )

    Province.create(:country_id => 2,
      :name => 'Guanacaste'
      #:position =>
    )

    Province.create(:country_id => 2,
      :name => 'Heredia'
      #:position =>
    )

    Province.create(:country_id => 2,
      :name => 'Limón'
      #:position =>
    )

    Province.create(:country_id => 2,
      :name => 'Puntarenas'
      #:position =>
    )

    Province.create(:country_id => 2,
      :name => 'San José'
      #:position =>
    )


    Style.delete_all

    Style.create(:name => 'A-Frame',
      :user_defined => false
    )

    Style.create(:name => 'Colonial',
      :user_defined => false
    )

    Style.create(:name => 'Wonky-jawed',
      :user_defined => true
    )


    AgencyJurisdiction.delete_all

    AgencyJurisdiction.create(:agency_id => 2,
      :market_id => 1
    )

    AgencyJurisdiction.create(:agency_id => 2,
      :market_id => 2
    )


    AgencyRelationship.delete_all

    AgencyRelationship.create(:agency_id => 2,
      :partner_id => 2
    )

    AgencyRelationship.create(:agency_id => 3,
      :partner_id => 1
    )


    Barrio.delete_all
    
    Barrio.create(:name => 'Heredia',
      :country_id => 2,
      :market_id => 1,
      :zone_id => 5,
      :province_id => 4
      #:position => ,
    )

    Barrio.create(:name => 'Downtown Heredia',
      :country_id => 2,
      :market_id => 1,
      :zone_id => 5,
      :province_id => 4
      #:position => ,
    )

    Barrio.create(:name => 'Santo Domingo',
      :country_id => 2,
      :market_id => 1,
      :zone_id => 5,
      :province_id => 4
      #:position => ,
    )

    Barrio.create(:name => 'Santo Rafael',
      :country_id => 2,
      :market_id => 1,
      :zone_id => 5,
      :province_id => 4
      #:position => ,
    )

    Barrio.create(:name => 'Santa Lucía',
      :country_id => 2,
      :market_id => 1,
      :zone_id => 5,
      :province_id => 4
      #:position => ,
    )

    Barrio.create(:name => 'Jacó',
      :country_id => 2,
      :market_id => 2,
      :zone_id => 2,
      :province_id => 6
      #:position => ,
    )

    Barrio.create(:name => 'Jacó Beach',
      :country_id => 2,
      :market_id => 2,
      :zone_id => 2,
      :province_id => 6
      #:position => ,
    )

    Barrio.create(:name => 'Playa Hermosa',
      :country_id => 2,
      :market_id => 2,
      :zone_id => 2,
      :province_id => 6
      #:position => ,
    )


    Listing.delete_all

    Listing.create(:property_id => 2,
      :listing_type_id => 1,
      :label => 'sale',
      :name => 'Graceland Estate',
      :description => "Elvis: another victim of subprime lending",
      :ask_amount => 650000,
      :ask_currency_id => 2,
      :close_amount => 550000,
      :close_currency_id => 2,
      :publish_date => '2009-03-18',
      :contract_expiration_date => '2010-03-18',
      :listing_expiration_date => '2011-03-18',
      :date_available => '2009-02-18',
      :show_agent => 0,
      :show_agency => 0,
      :admin_notes => "Termite-infested",
      :sold => 0,
      :approved => 1
    )
    Listing.create(:property_id => 2,
      :listing_type_id => 2,
      :label => 'rental',
      :name => 'The Original Neverland',
      :description => "Renting out rooms to pay mortgage",
      :ask_amount => 800,
      :ask_currency_id => 1,
      :close_amount => 600000,
      :close_currency_id => 1,
      :publish_date => '2009-04-13',
      :contract_expiration_date => '2010-04-13',
      :listing_expiration_date => '2011-04-13',
      #:date_available => '2009-04-13',
      :show_agent => 1,
      :show_agency => 1,
      :admin_notes => "Any room you want",
      :sold => 0,
      :approved => 1
    )

    Listing.create(:property_id => 3,
      :listing_type_id => 1,
      :label => 'business',
      :name => 'Motel Modesto',
      :description => "Mirrors on the ceiling... champaigne on ice... she said...",
      :ask_amount => 800000,
      :ask_currency_id => 1,
      :close_amount => 575000,
      :close_currency_id => 2,
      :publish_date => '2009-03-19',
      :contract_expiration_date => '2010-03-19',
      :listing_expiration_date => '2011-03-19',
      #:date_available => '2009-02-19',
      :show_agent => 1,
      :show_agency => 1,
      :admin_notes => "There is plenty of room here",
      :sold => 1,
      :approved => 1
    )

    Listing.create(:property_id => 1,
      :listing_type_id => 1,
      :label => 'partner version',
      :name => 'Haunted Mansion of Monsters',
      :description => "This beautiful mansion is haunted like your mamma!",
      :ask_amount => 1200000,
      :ask_currency_id => 1,
      :close_amount => 1000000,
      :close_currency_id => 1,
      :publish_date => '2009-03-17',
      :contract_expiration_date => '2010-03-17',
      :listing_expiration_date => '2011-03-17',
      #:date_available => '2009-02-17',
      :show_agent => 1,
      :show_agency => 1,
      :admin_notes => "Here are some nifty notes about this place blah blah",
      :sold => 1,
      :approved => 1
    )


    CategoryAssignment.delete_all

    CategoryAssignment.create(:category_assignable_type => 'ListingType',
      :category_assignable_id => 1,
      :category_id => 1,
      :primary_category => false
    )
    
    CategoryAssignment.create(:category_assignable_type => 'ListingType',
      :category_assignable_id => 1,
      :category_id => 2,
      :primary_category => false
    )
    
    CategoryAssignment.create(:category_assignable_type => 'ListingType',
      :category_assignable_id => 1,
      :category_id => 3,
      :primary_category => false
    )
    
    CategoryAssignment.create(:category_assignable_type => 'ListingType',
      :category_assignable_id => 1,
      :category_id => 4,
      :primary_category => false
    )
    
    CategoryAssignment.create(:category_assignable_type => 'ListingType',
      :category_assignable_id => 1,
      :category_id => 5,
      :primary_category => false
    )
    
    CategoryAssignment.create(:category_assignable_type => 'ListingType',
      :category_assignable_id => 2,
      :category_id => 2,
      :primary_category => false
    )
    
    CategoryAssignment.create(:category_assignable_type => 'ListingType',
      :category_assignable_id => 2,
      :category_id => 3,
      :primary_category => false
    )
    
    CategoryAssignment.create(:category_assignable_type => 'ListingType',
      :category_assignable_id => 2,
      :category_id => 4,
      :primary_category => false
    )

    CategoryAssignment.create(:category_assignable_type => 'Property',
      :category_assignable_id => 1,
      :category_id => 1,
      :primary_category => true
    )

    CategoryAssignment.create(:category_assignable_type => 'Property',
      :category_assignable_id => 1,
      :category_id => 2,
      :primary_category => false
    )

    CategoryAssignment.create(:category_assignable_type => 'Property',
      :category_assignable_id => 1,
      :category_id => 3,
      :primary_category => false
    )

    CategoryAssignment.create(:category_assignable_type => 'Property',
      :category_assignable_id => 1,
      :category_id => 4,
      :primary_category => false
    )
    
    CategoryAssignment.create(:category_assignable_type => 'Property',
      :category_assignable_id => 2,
      :category_id => 1,
      :primary_category => true
    )
    
    CategoryAssignment.create(:category_assignable_type => 'Property',
      :category_assignable_id => 3,
      :category_id => 2,
      :primary_category => true
    )

    CategoryAssignment.create(:category_assignable_type => 'Listing',
      :category_assignable_id => 1,
      :category_id => 4,
      :primary_category => false
    )

    CategoryAssignment.create(:category_assignable_type => 'Listing',
      :category_assignable_id => 1,
      :category_id => 5,
      :primary_category => false
    )


    FeatureAssignment.delete_all

    FeatureAssignment.create(:feature_assignable_type => 'ListingType',
      :feature_assignable_id => 1,
      :feature_id => 1,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'ListingType',
      :feature_assignable_id => 1,
      :feature_id => 2,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'ListingType',
      :feature_assignable_id => 1,
      :feature_id => 3,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'ListingType',
      :feature_id => 4,
      :feature_assignable_id => 1,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'ListingType',
      :feature_assignable_id => 1,
      :feature_id => 5,
      :highlighted_feature => true
  )

    FeatureAssignment.create(:feature_assignable_type => 'ListingType',
      :feature_assignable_id => 1,
      :feature_id => 6,
      :highlighted_feature => false
    )


    FeatureAssignment.create(:feature_assignable_type => 'ListingType',
      :feature_assignable_id => 1,
      :feature_id => 7,
      :highlighted_feature => false
    )

    FeatureAssignment.create(:feature_assignable_type => 'ListingType',
      :feature_assignable_id => 2,
      :feature_id => 1,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'ListingType',
      :feature_assignable_id => 2,
      :feature_id => 2,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'ListingType',
      :feature_assignable_id => 2,
      :feature_id => 3,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'ListingType',
      :feature_assignable_id => 2,
      :feature_id => 5,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'ListingType',
      :feature_assignable_id => 2,
      :feature_id => 7,
      :highlighted_feature => false
    )

    FeatureAssignment.create(:feature_assignable_type => 'Property',
      :feature_assignable_id => 1,
      :feature_id => 1,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'Property',
      :feature_assignable_id => 1,
      :feature_id => 2,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'Property',
      :feature_assignable_id => 1,
      :feature_id => 3,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'Property',
      :feature_assignable_id => 1,
      :feature_id => 4,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'Property',
      :feature_assignable_id => 1,
      :feature_id => 5,
      :highlighted_feature => false
    )

    FeatureAssignment.create(:feature_assignable_type => 'Property',
      :feature_assignable_id => 2,
      :feature_id => 1,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'Property',
      :feature_assignable_id => 2,
      :feature_id => 2,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'Property',
      :feature_assignable_id => 2,
      :feature_id => 3,
      :highlighted_feature => false
    )

    FeatureAssignment.create(:feature_assignable_type => 'Listing',
      :feature_assignable_id => 1,
      :feature_id => 6,
      :highlighted_feature => true
    )

    FeatureAssignment.create(:feature_assignable_type => 'Listing',
      :feature_assignable_id => 1,
      :feature_id => 7,
      :highlighted_feature => false
    )


    StyleAssignment.delete_all
    
    StyleAssignment.create(:style_assignable_type => 'ListingType',
      :style_assignable_id => 1,
      :style_id => 1,
      :primary_style => false
    )
    
    StyleAssignment.create(:style_assignable_type => 'ListingType',
      :style_assignable_id => 1,
      :style_id => 2,
      :primary_style => false
    )
    
    StyleAssignment.create(:style_assignable_type => 'ListingType',
      :style_assignable_id => 1,
      :style_id => 3,
      :primary_style => false
    )
    
    StyleAssignment.create(:style_assignable_type => 'ListingType',
      :style_assignable_id => 2,
      :style_id => 2,
      :primary_style => false
    )
    
    StyleAssignment.create(:style_assignable_type => 'ListingType',
      :style_assignable_id => 2,
      :style_id => 3,
      :primary_style => false
    )

    StyleAssignment.create(:style_assignable_type => 'Property',
      :style_assignable_id => 1,
      :style_id => 1,
      :primary_style => true
    )

    StyleAssignment.create(:style_assignable_type => 'Property',
      :style_assignable_id => 1,
      :style_id => 2,
      :primary_style => true
    )

    StyleAssignment.create(:style_assignable_type => 'Property',
      :style_assignable_id => 2,
      :style_id => 1,
      :primary_style => true
    )

    StyleAssignment.create(:style_assignable_type => 'Property',
      :style_assignable_id => 3,
      :style_id => 2,
      :primary_style => true
    )

    StyleAssignment.create(:style_assignable_type => 'Property',
      :style_assignable_id => 3,
      :style_id => 3,
      :primary_style => false
    )


# Users need to be added by registering so that encrypted password is
# saved correctly
#    User.delete_all

#    User.create(:login => 'brian',
#      :crypted_password => 'x',
#      :password_salt => 'x',
#      :persistence_token => 'x',
#      :single_access_token => 'x',
#      :perishable_token => 'x',
#      :login_count => 0,
#      :failed_login_count => 0,
#      :last_request_at => '2009-01-01 00:00:00',
#      :current_login_at => '2009-01-01 00:00:00',
#      :last_login_at => '2009-01-01 00:00:00',

#      :first_name => 'Brian',
#      :last_name => 'Warren',
#      :sex => 'm',
#      :nationality_id => 1,
#      :email => 'brian.scott.warren@gmail.com',
#      :email_public => 'brian@barrioearth.com',
#      :phone_home => '2817518838',
#      :phone_work => '2819703700',
#      :phone_mobile => '8327238129',
#      :phone_fax => '2819703702',
#      :address1 => '10960 Millridge N. Dr.',
#      :address2 => 'Suite 113',
#      :postal_code => '77070',
#      :original_referer_url => 'http://www.meeps.com?who=barrioearth.com',
#      :date_verified => '2009-03-10 12:33:22'
#    )

#    User.create(:login => 'phil',
#      :crypted_password => 'x',
#      :password_salt => 'x',
#      :persistence_token => 'x',
#      :single_access_token => 'x',
#      :perishable_token => 'x',
#      :login_count => 0,
#      :failed_login_count => 0,
#      :last_request_at => '2009-01-01 00:00:00',
#      :current_login_at => '2009-01-01 00:00:00',
#      :last_login_at => '2009-01-01 00:00:00',

#      :first_name => 'Phil',
#      :last_name => 'Hemion',
#      :sex => 'm',
#      :nationality_id => 1,
#      :email => 'phemion@hotmail.com',
#      :email_public => '',
#      :phone_home => '50622657777',
#      :phone_work => '50622656666',
#      :phone_mobile => '50683856952',
#      :phone_fax => '',
#      :address1 => 'Somewhere.',
#      :address2 => '',
#      :postal_code => '',
#      :original_referer_url => 'http://www.boops.com?who=barrioearth.com',
#      :date_verified => '2009-03-12 14:23:51'
#    )

  end

  def self.down
#    Administrator.delete_all
#    AdministratorJurisdiction.delete_all
    Agency.delete_all
    AgencyJurisdiction.delete_all
    AgencyRelationship.delete_all
#    Agent.delete_all
#    AgentAffiliation.delete_all
    Barrio.delete_all
    Category.delete_all
    CategoryAssignment.delete_all
    Country.delete_all
    Currency.delete_all
    Feature.delete_all
    FeatureAssignment.delete_all
    Image.delete_all
    InformationRequest.delete_all
    Listing.delete_all
    ListingType.delete_all
    Market.delete_all
#    User.delete_all
    Property.delete_all
    Province.delete_all
    Style.delete_all
    StyleAssignment.delete_all
    Zone.delete_all
  end
end

