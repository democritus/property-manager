ActionController::Routing::Routes.draw do |map|

  # TODO: Is this the best place to add these routes, or should they be
  # integrated with resource routes?
  
  # Map non-model placeholder image methods (must come before resource routes)
  map.connect 'property_images/large_glider_placeholder',
    :controller => :property_images, :action => :large_glider_placeholder
  map.connect 'property_images/listing_glider_placeholder',
    :controller => :property_images, :action => :listing_glider_placeholder
  map.connect 'property_images/mini_glider_placeholder',
    :controller => :property_images, :action => :mini_glider_placeholder
  map.connect 'property_images/mini_glider_recent',
    :controller => :property_images, :action => :mini_glider_recent
  map.connect 'property_images/mini_glider_suggested',
    :controller => :property_images, :action => :mini_glider_suggested
  map.connect 'property_images/mini_glider_similar',
    :controller => :property_images, :action => :mini_glider_similar
  map.connect 'agency_images/large_glider_placeholder',
    :controller => :agency_images, :action => :large_glider_placeholder
  
  #
  # Standard routes
  #
  map.resources :countries,
    :member => [ :contact, :links ],
    :only => [ :show, :contact, :links ]
  
  # User / User authentication routes
  map.resource :account,
    :controller => :users,
    :only => [ :new, :create ]
  map.resource :user_session,
    :only => [ :new, :create, :destroy ]
  map.resources :password_resets,
    :only => [ :new, :create, :edit, :update ]
  
  # Shallow routes - member routes (with id) accessed directly, other
  # routes are nested
  map.resources :agency_images,
    #:except => [ :index, :new, :create, :edit, :update, :destroy ],
    :only => [ :show, :thumb, :large_glider, :mini_glider ],
    :member => { :thumb => :get, :large_glider => :get, :mini_glider => :get }
  map.resources :agency_logos,
    :only => [ :show, :thumb ],
    :member => { :thumb => :get }
  map.resources :market_images,
    :only => [ :show, :thumb ],
    :member => { :thumb => :get }
  map.resources :property_images,
    :except => [ :index, :new, :create, :edit, :update, :destroy ],
    #:only => [ :show, :thumb, :medium, :fullsize, :original, :large_glider,
    #  :listing_glider, :mini_glider ]
    :member => { :thumb => :get, :medium => :get, :fullsize => :get,
      :original => :get, :large_glider => :get, :listing_glider => :get,
      :mini_glider => :get }
  map.resources :user_icons,
    :only => [ :show, :small ],
    :member => { :small => :get }

  #
  # Nested routes
  #
  map.resources :users do |users|
    users.resources :user_icons,
      :except => :show,
      :member => { :small => :get },
      :requirements => { :context_type => 'users' }
  end
  
  map.resources :agencies,
  :only => [ :show, :contact, :links, :default_logo ],
  :member => {
    :contact => :get,
    :links => :get,
    :default_logo => :get
  } do |agencies|
    agencies.resources :information_requests,
      :only => [ :new, :create ],
      :requirements => { :context_type => 'agencies' }
  end
  
  map.resources :listings,
  :as => :real_estate,
  :only => [ :show, :index ],
  :member => { :glider_image_swap => :get },
  :collection => { :featured_glider => :get } do |listings|
    listings.resources :information_requests,
      :only => [ :new, :create ],
      :requirements => { :context_type => 'listings' }
  end
    
  # Admin routes
  map.namespace(:admin) do |admin|
  
    admin.resources :categories,
      :currencies,
      :features,
      :information_requests,
        { :only => [ :index, :show, :edit, :update, :destroy ] },
      :styles
    
    admin.resources :countries do |countries|
      countries.resources :markets,
        :requirements => { :context_type => 'countries' }
      countries.resources :provinces,
        :except => [:update, :destroy],
        :requirements => { :context_type => 'countries' }
      countries.resources :zones,
        :except => [:update, :destroy],
        :requirements => { :context_type => 'countries' }
    end
    
    admin.resources :listing_types do |listing_types|
      listing_types.resources :category_assignments,
        :only => [ :index, :edit, :update ],
        :requirements => { :context_type => 'listing_types' }
      listing_types.resources :feature_assignments,
        :only => [ :index, :edit, :update ],
        :requirements => { :context_type => 'listing_types' }
      listing_types.resources :style_assignments,
        :only => [ :index, :edit, :update ],
        :requirements => { :context_type => 'listing_types' }
    end
    
    admin.resources :markets, :only => :show do |markets|
      markets.resources :barrios,
        :member => { :update_places => :get },
        :new => { :update_places => :get },
        :requirements => { :context_type => 'markets' }
      markets.resources :market_images,
        :except => :show,
        :requirements => { :context_type => 'markets' },
        :member => { :thumb => :get }
    end
    
    admin.resources :agencies,
    :new => {
      :country_pivot => :get,
      :auto_complete_for_agency_broker_id => :post # TODO: change to :get
    },
    :member => {
      :country_pivot => :get,
      :auto_complete_for_agency_broker_id => :post # TODO: change to :get
    } do |agencies|
      agencies.resources :agency_images,
        :except => :show,
        :requirements => { :context_type => 'agencies' },
        :member => { :thumb => :get }
      agencies.resources :agency_logos,
        :except => :show,
        :requirements => { :context_type => 'agencies' },
        :member => { :thumb => :get }
      agencies.resources :agents,
        :requirements => { :context_type => 'agencies' },
        :new => {
          :auto_complete_for_agent_user_id => :post # TODO: change to :get
        }
      agencies.resources :information_requests,
        :only => [ :index, :edit, :update, :destroy ],
        :requirements => { :context_type => 'agencies' }
      agencies.resources :properties,
        :new => { :barrio_select => :get },
        :member => { :barrio_select => :get },
        :requirements => { :context_type => 'agencies' }
      agencies.resources :site_texts,
        :requirements => { :context_type => 'agencies' }
    end
    
    admin.resources :listings, :only => :show do |listings|
      listings.resources :property_images,
        :except => :show,
        :member => { :thumb => :get, :medium => :get, :fullsize => :get,
          :original => :get, :large_glider => :get, :listing_glider => :get,
          :mini_glider => :get },
        :requirements => { :context_type => 'listings' }
      listings.resources :category_assignments,
        :only => [ :index, :edit, :update ],
        :requirements => { :context_type => 'listings' }
      listings.resources :feature_assignments,
        :only => [ :index, :edit, :update ],
        :requirements => { :context_type => 'listings' }
      listings.resources :information_requests,
        :only => [ :index, :edit, :update, :destroy ],
        :requirements => { :context_type => 'listings' }
      listings.resources :style_assignments,
        :only => [ :index, :edit, :update ],
        :requirements => { :context_type => 'listings' }
    end
    
    admin.resources :properties,
    :only => :show do |properties|
      properties.resources :category_assignments,
        :only => [ :index, :edit, :update ],
        :requirements => { :context_type => 'properties' }
      properties.resources :feature_assignments,
        :only => [ :index, :edit, :update ],
        :requirements => { :context_type => 'properties' }
      properties.resources :style_assignments,
        :only => [ :index, :edit, :update ],
        :requirements => { :context_type => 'properties' }
      properties.resources :listings,
        :new => { :listing_type_pivot => :get },
        :member => { :listing_type_pivot => :get },
        :requirements => { :context_type => 'properties' }
      properties.resources :property_images,
        :except => :show,
        :member => { :thumb => :get, :medium => :get, :fullsize => :get,
          :original => :get, :large_glider => :get, :listing_glider => :get,
          :mini_glider => :get },
        :requirements => { :context_type => 'properties' }
    end
      
    admin.resources :users do |users|
      users.resources :user_icons,
        :except => :show,
        :member => { :small => :get },
        :requirements => { :context_type => 'users' }
    end
  end
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :user => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # EXAMPLE: map locale for URLs where locale is passed like:
  # http://localhost:3001/nl/books
  # used in conjunction with ApplicationController::default_url_options and
  # grabbing locale from params[:locale]
  # map.resources :books, :path_prefix => '/:locale'
  #
  # Also need this for the website root page (should go right before map.root)
  # map.dashboard '/:locale', :controller => "dashboard"

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => :agencies, :action => :show
  #map.root :controller => "user_sessions", :action => "new" # optional, this just sets the root route

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
    
  # Ajax routes - access these methods directly for ajax calls
  map.connect 'admin/agencies/:agency_id/properties/barrio_select',
    :controller => :properties, :action => :barrio_select
    
  # Intercept /contact and re-route to agencies controller
  map.connect 'contact',
    :controller => :agencies, :action => :contact
  map.connect 'links',
    :controller => :agencies, :action => :links
  
  # Admin root
  map.connect 'admin',
    :controller => 'admin/agencies', :action => :index
end
