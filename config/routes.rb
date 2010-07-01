ActionController::Routing::Routes.draw do |map|

  # Listings search
  # Cachable search urls compatible with Searchlogic (including pagination)
  bound_params_string = 'real_estate'
  bound_params_requirements = {}
  bound_params_defaults = {}
  LISTING_PARAMS_MAP.each do |param|
    bound_params_string += '/:' + param[:key].to_s
    bound_params_requirements.merge!(param[:key] => %r([^/;,?]+))
    #bound_params_defaults.merge!(param[:key] => nil)
  end
  map.connect(
    bound_params_string,
    bound_params_defaults.merge(
      :controller => :listings,
      :action => :index,
      :requirements => bound_params_requirements
    )
  )
  
  #
  # Standard routes
  #
  map.resources :countries, :only => :show
  
  # User / User authentication routes
  map.resource :account,
    :controller => :users,
    :only => [ :new, :create ]
  map.resource :user_session,
    :only => [ :new, :create, :destroy ]
  map.resources :password_resets,
    :only => [ :new, :create, :edit, :update ]
  
  map.resources :users
  
  # Shallow routes - member routes (with id) accessed directly, other
  # routes are nested
  map.resources :property_images,
    :only => [ :featured, :show, :fullsize, :original ],
    :member => { :featured => :get, :fullsize => :get, :original => :get }
    
  #
  # Nested routes
  #
  map.resources :agencies,
    :only => [ :show, :contact, :links ],  
    :collection => { :large_glider_placeholder => :get },
    :member => {
      :contact => :get,
      :links => :get
    } do |agencies|
    agencies.resources :information_requests,
      :only => :create,
      :requirements => { :context_type => 'agencies' }
  end
  
  map.resources :listings,
    :as => :real_estate,
    :only => [ :show, :index ],
    :member => { :glider_image_swap => :get },
    :collection => { :featured_glider => :get } do |listings|
    listings.resources :information_requests,
      :only => :create,
      :requirements => { :context_type => 'listings' }
  end
    
  # Admin routes
  map.namespace(:admin) do |admin|
    admin.resources :agencies,
      :collection => {
        :country_pivot => :get,
        :auto_complete_for_agency_broker_id => :post # TODO: change to :get
      } do |agencies|
      agencies.resources :agency_images,
        :except => :show,
        :requirements => { :context_type => 'agencies' }
      agencies.resources :agency_logos,
        :except => :show,
        :requirements => { :context_type => 'agencies' }
      agencies.resources :agents,
        :requirements => { :context_type => 'agencies' },
        :collection => {
          :auto_complete_for_agent_user_id => :post # TODO: change to :get
        }
      agencies.resources :information_requests,
        :only => [ :index, :edit, :update, :destroy ],
        :requirements => { :context_type => 'agencies' }
      agencies.resources :properties,
        :collection => { :barrio_select => :get },
        :requirements => { :context_type => 'agencies' }
      agencies.resources :site_texts,
        :requirements => { :context_type => 'agencies' }
    end
    
    admin.resources :cantons, :only => :show do |cantons|
      cantons.resources :barrios,
        :collection => {
          :update_provinces => :get,
          :update_markets => :get,
          :update_cantons => :get
        },
        :requirements => { :context_type => 'provinces' }
    end
    
    admin.resources :categories,
      :currencies,
      :features,
      :information_requests,
        { :only => [ :index, :show, :edit, :update, :destroy ] },
      :styles
    
    admin.resources :countries do |countries|
      countries.resources :markets,
        :except => [:update, :destroy],
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
    
    admin.resources :markets, :only => :show do |markets|
      markets.resources :market_images,
        :except => :show,
        :requirements => { :context_type => 'markets' }
    end
    
    admin.resources :market_segments do |market_segments|
      market_segments.resources :market_segment_images,
        :except => :show,
        :requirements => { :context_type => 'market_segment' }
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
        :requirements => { :context_type => 'properties' }
    end
    
    admin.resources :provinces, :only => :show do |markets|
      markets.resources :cantons,
        :collection => { :update_provinces => :get },
        :requirements => { :context_type => 'provinces' }
    end
    
    admin.resources :users do |users|
      users.resources :user_icons,
        :except => [ :show, :new, :create ],
        :member => { :small => :get },
        :requirements => { :context_type => 'users' }
    end
  end
  
  # Image routes
  map.namespace(:images) do |images|
    images.resources :agencies,
      :only => :default_logo,  
      :member => { :default_logo => :get }
    images.resources :agency_images,
      :only => [ :show, :thumb, :large_glider, :large_glider_placeholder ],
      :member => {
        :thumb => :get,
        :large_glider => :get,
        :large_glider_placeholder => :get
      }
    images.resources :agency_logos,
      :only => [ :show, :thumb ],
      :member => { :thumb => :get }
    images.resources :market_images,
      :only => [ :show, :thumb ],
      :member => { :thumb => :get }
    images.resources :market_segment_images,
      :only => [ :show, :large_glider, :mini_glider, :thumb ],
      :member => {
        :thumb => :get,
        :large_glider => :get,
        :mini_glider => :get
      }
    images.resources :property_images,
      :only => [ :show, :thumb, :medium, :fullsize, :original, :listing_glider,
        :listing_glider_placeholder, :mini_glider, :mini_glider_placeholder,
        :mini_glider_suggested, :mini_glider_similar, :mini_glider_recent,
        :large_glider, :large_glider_placeholder, :featured ],
      :member => {
        :thumb => :get,
        :medium => :get,
        :fullsize => :get,
        :original => :get,
        :listing_glider => :get,
        :mini_glider => :get,
        :large_glider => :get,
        :featured => :get
      },
      :collection => {
        :large_glider_placeholder => :get,
        :listing_glider_placeholder => :get,
        :mini_glider_placeholder => :get,
        :mini_glider_recent => :get,
        :mini_glider_suggested => :get,
        :mini_glider_similar => :get
      }
    images.resources :properties,
      :only => [ :default_thumb, :default_medium ],
      :collection => { :default_thumb => :get, :default_medium => :get }
  end
        
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog',
  # :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :user => { :short => :get,
  # :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ],
  # :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController
  # (app/controllers/admin/products_controller.rb)
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

  # You can have the root of your site routed with map.root -- just remember
  # to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => :agencies, :action => :show
  #map.root :controller => "user_sessions", :action => "new" # optional, this
  # just sets the root route

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible
  # via GET requests. You should
  # consider removing the them or commenting them out if you're using named
  # routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
    
  # REMOVED: moved these to resource routes as :collection methods
  # Ajax routes - access these methods directly for ajax calls
  # TODO: move all ajax routes here as regular routes... no need to have
  # resource routes using up memory for these
  #map.connect 'admin/agencies/auto_complete_for_agency_broker_id',
  #  :controller => :properties, :action => :auto_complete_for_agency_broker_id
  #map.connect 'admin/agencies/:agency_id/agents/auto_complete_for_agent_user_id',
  #  :controller => :properties, :action => :auto_complete_for_agent_user_id
  #map.connect 'admin/agencies/:agency_id/properties/barrio_select',
  #  :controller => :properties, :action => :barrio_select
    
  # Intercept /contact and re-route to agencies controller
  map.connect 'contact',
    :controller => :agencies, :action => :contact
  map.connect 'links',
    :controller => :agencies, :action => :links
  
  # Admin root
  map.connect 'admin',
    :controller => 'admin/agencies', :action => :index
end
