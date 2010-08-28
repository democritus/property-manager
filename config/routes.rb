ActionController::Routing::Routes.draw do |map|
  
  # Normal view - cached
  map.resources :real_estate,
    :controller => :listings,
    :only => [ :show, :index, :featured_glider ],
    :member => { :glider_image_swap => :get },
    :collection => { :featured_glider => :get } do |listings|
    listings.resources :information_requests,
      :only => :create,
      :requirements => { :context_type => 'listings' }
  end
  
  # Admin view - not cached
  map.resources :listings,
    :controller => :listings,
    :only => [ :show, :index, :featured_glider ],
    :member => { :glider_image_swap => :get },
    :collection => { :featured_glider => :get } do |listings|
    listings.resources :information_requests,
      :only => :create,
      :requirements => { :context_type => 'listings' }
  end
  
  # Listings search
  # Cachable search urls compatible with Searchlogic (including pagination)
  search_routes = []
  length = SEARCH_PARAMS_MAP.length
  (0..length).each do |outer_offset|
    search_routes[outer_offset] = {
      :params => '',
      :requirements => {}
    }
    SEARCH_PARAMS_MAP.each_with_index do |param, inner_offset|
      break if inner_offset == outer_offset
      search_routes[outer_offset][:params] += '/:' + param[:key].to_s
      search_routes[outer_offset][:requirements].merge!(
        param[:key] => %r([^/;,?]+) )
    end
  end
  paginate_routes = []
  length = PAGINATE_PARAMS_MAP.length
  (0..length - 1).each do |outer_offset|
    PAGINATE_PARAMS_MAP.each_with_index do |param, inner_offset|
      break if inner_offset == outer_offset + 1
      regex = case param[:key]
      when :page
        %r(\d)
      else # when :order
#        %r(asc|desc)
#        %r((.+)(\sasc|\sdesc))
#        %r(([^\s/;,?-]+)(\sasc|\sdesc))
        %r(([^\s/;,?-]+)(\s|%20)(asc|desc))
      end
      paginate_routes[outer_offset] = {
        :params => '/:' + param[:key].to_s,
        :requirements => { param[:key] => regex }
      }
    end
  end
  defaults = { :controller => :listings, :action => :index }
#  [ :real_estate, :listings ].each do |controller_alias|
  [ :real_estate ].each do |controller_alias|    
    # Three loops: 1) search params only, 2) search params + page,
    # 3) page params + order
    (0..3).each do |i|
      search_routes.each do |my_route|
        append_params = ''
        merge_requirements = {}
        unless i == 3
          case i
          when 0, 1 # :page and :order OR just :page
            (0..1-i).each do |paginate_mode|
              append_params += paginate_routes[paginate_mode][:params]
              merge_requirements.merge!(
                paginate_routes[paginate_mode][:requirements] )
            end
          else # when 2 - just :order
            append_params += paginate_routes[1][:params]
            merge_requirements.merge!( paginate_routes[1][:requirements] )
          end
        end
        map.connect(
          "/#{controller_alias}" + my_route[:params] + append_params,
          defaults.merge(
            :requirements => my_route[:requirements].merge(
              merge_requirements
            )
          )
        )
      end
    end
  end
    
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
    
  # Admin routes
  map.namespace(:admin) do |admin|
    admin.resources :agencies,
      :collection => {
        :country_pivot => :get,
        :auto_complete_for_agency_broker_id => :post # TODO: change to :get
      } do |agencies|
      agencies.resources :agency_images,
        :only => [ :new, :create, :edit, :update, :index ],
        :requirements => { :context_type => 'agencies' }
      agencies.resources :agency_logos,
        :only => [ :new, :create, :edit, :update, :index ],
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
        :only => [ :new, :create, :edit, :update, :index ],
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
        :only => [ :new, :create, :edit, :update, :index ],
        :requirements => { :context_type => 'properties' }
    end
    
    admin.resources :provinces, :only => :show do |markets|
      markets.resources :cantons,
        :collection => { :update_provinces => :get },
        :requirements => { :context_type => 'provinces' }
    end
    
    admin.resources :users do |users|
      users.resources :user_icons,
        :only => [ :new, :create, :edit, :update, :index ],
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
