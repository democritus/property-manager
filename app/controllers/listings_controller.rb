class ListingsController < ApplicationController
  
  caches_page :index, :show, :featured_glider
  
  before_filter :set_search_params
  
  # GET /listings
  # GET /listings.xml
  def index
    # Record user's search results for the most recent listings index they
    # have viewed
    session[:last_seen_params] = search_params
    
    # Searchlogic filtering
  
    # TODO: figure out how to pass order by params as searchlogic parameter
    # instead of this ugly named scope hack
    
    unless params[:order].blank?
      direction = 'ascend_by'
      if params[:order_dir]
        if params[:order_dir].downcase == 'desc'
          direction = 'descend_by'
        end
      end
    end
    unless active_agency.master_agency
      if direction
        @search = active_agency.listings.send(
          "#{direction}_#{params[:order]}").search(search_params)
        #@search = Listing.by_agency(active_agency.id).send(
        #  "#{direction}_#{params[:order]}").search(search_params)
      else
        @search = active_agency.listing.search(search_params)
        #@search = Listing.by_agency(active_agency.id).search(search_params)
      end
    else
      if direction
        @search = Listing.regular_index.send(
          "#{direction}_#{params[:order]}").search(search_params)
      else
        @search = Listing.regular_index.search(search_params)
      end
    end
    @listings = @search.paginate :page => params[:page]
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @listings }
    end
  end
  
# REMOVED: moved to partial
#  # GET /listings/large_glider
#  def featured_glider
#    if active_agency.master_agency
#      @featured_glider = featured_listings = Listing.featured
#    else
#      @featured_glider = featured_listings = active_agency.listings.featured
#    end
#    # Prepend agency to collection of listings so that the first group of
#    # images to appear in the glider are agency images
#    if active_agency.agency_images
#      if active_agency.agency_images.length > 2
#        splash_name = active_agency.name
#        splash_object = active_agency
#      end
#    end
#    # If insufficient agency images, use generic images for market segment
#    unless splash_name
#      if active_agency.market_segment
#        if active_agency.market_segment.market_segment_images
#          if active_agency.market_segment.market_segment_images.length > 2
#            splash_name = active_agency.name
#            splash_object = active_agency.market_segment
#          end
#        end
#      end
#    end
#    if splash_name
#      #@featured_glider.insert(0, splash_name) # Overlay text
#      @featured_glider.insert(0, splash_object) # Object containing images
#    end
#    
#    render :layout => false
#  end

  # GET /listings/1
  # GET /listings/1.xml
  def show
    @listing = Listing.find(params[:id])

    # User might send information request
    if session[:information_request] # Load data from session after redirect
      @information_request = session[:information_request]
      session.delete(:information_request)
    else
      @information_request = InformationRequest.new
    end

    respond_to do |format|
      format.html { add_recent_listing(@listing) } # remember listings seen
      format.xml  { render :xml => @listing }
    end

  end
  
  # AJAX target for listing image swap for glider images
  def glider_image_swap
    image = PropertyImage.find(params[:image_id])
        
    render :partial => 'glider_image_swap',
      :layout => false,
      :locals => { :image => image }
  end


  private
  
  def order
    order_params = {}
    unless params[:order].blank?
      order = params[:order] + ' IS NULL, ' + params[:order]
      order_params.merge!('ascend_by_')
      direction = ''
      if params[:order_dir]
        if params[:order_dir].upcase == 'DESC'
          direction = ' DESC'
        end
      end    
      unless params[:order_dir].blank?
        direction = ' ' + params[:order_dir]
      end
      
      return order + direction
    end
    
    # TODO: create scheme to change order of listings so that the same listings
    # don't always show up at the top of the list
    if search_params.has_key?(
      'property_barrio_canton_province_country_cached_slug_equals')
#      'barrio_province_country_cached_slug_equals')
      if search_params.has_key?('categories_cached_slug_equals')
        if search_params.has_key?('property_barrio_market_cached_slug_equals')
#        if search_params.has_key?('barrio_market_cached_slug_equals')
          if search_params.has_key?('property_barrio_cached_slug_equals')
#          if search_params.has_key?('barrio_cached_slug_equals')
            order = 'listings.ask_amount'
          else
            order = 'barrios.name, listings.ask_amount'
          end
        else
          order = 'markets.name, barrios.name'
        end
      else
        if search_params.has_key?('property_barrio_market_cached_slug_equals')
#        if search_params.has_key?('barrio_market_cached_slug_equals')
          if search_params.has_key?('property_barrio_cached_slug_equals')
#          if search_params.has_key?('barrio_cached_slug_equals')
            order = 'categories.name'
          else
            order = 'categories.name, barrios.name'
          end
        else
          order = 'markets.name, barrios.name'
        end
      end
    else
      if search_params.has_key?('categories_cached_slug_equals')
        order = 'countries.name, markets.name, barrios.name'
      else
        order = 'listings.ask_amount'
      end
    end
    order = 'listings.created_at DESC' unless order
    
    return order
  end
  
  def infer_order
    unless params[:order].blank?
      order = params[:order] + ' IS NULL, ' + params[:order]
      direction = ''
      if params[:order_dir]
        if params[:order_dir].upcase == 'DESC'
          direction = ' DESC'
        end
      end    
      unless params[:order_dir].blank?
        direction = ' ' + params[:order_dir]
      end
      
      return order + direction
    end
    
    # TODO: create scheme to change order of listings so that the same listings
    # don't always show up at the top of the list
    if search_params.has_key?(
      'property_barrio_canton_province_country_cached_slug_equals')
#      'barrio_province_country_cached_slug_equals')
      if search_params.has_key?('categories_cached_slug_equals')
        if search_params.has_key?('property_barrio_market_cached_slug_equals')
#        if search_params.has_key?('barrio_market_cached_slug_equals')
          if search_params.has_key?('property_barrio_cached_slug_equals')
#          if search_params.has_key?('barrio_cached_slug_equals')
            order = 'listings.ask_amount'
          else
            order = 'barrios.name, listings.ask_amount'
          end
        else
          order = 'markets.name, barrios.name'
        end
      else
        if search_params.has_key?('property_barrio_market_cached_slug_equals')
#        if search_params.has_key?('barrio_market_cached_slug_equals')
          if search_params.has_key?('property_barrio_cached_slug_equals')
#          if search_params.has_key?('barrio_cached_slug_equals')
            order = 'categories.name'
          else
            order = 'categories.name, barrios.name'
          end
        else
          order = 'markets.name, barrios.name'
        end
      end
    else
      if search_params.has_key?('categories_cached_slug_equals')
        order = 'countries.name, markets.name, barrios.name'
      else
        order = 'listings.ask_amount'
      end
    end
    order = 'listings.created_at DESC' unless order
    
    return order
  end
  
  def add_recent_listing(listing)
    max = 12
    unless active_agency.master_agency
      agency_id = active_agency.id
    else
      agency_id = 0 # Zero means master agency (global mode)
    end
    unless session[:agencies]
      session[:agencies] = []
    end
    seen = false
    session[:agencies].each_with_index do |agency, i|
      if i == agency_id
        seen = true
      end
      break
    end
    unless seen
      session[:agencies][agency_id] = { :recent_listings => [] }
    end
    this_agency = session[:agencies][agency_id]
    recent_listings = session[:agencies][agency_id][:recent_listings]
    recent_listings.delete_if {|value| value == listing.id}
    if recent_listings.length >= (max - 1)
      recent_listings.slice!(0, max)
    end
    recent_listings.insert(0, listing.id)
  end
  
  # Combine readable constraints and searchlogic constraints
  def set_search_params
    @search_params = search_params
  end
end
