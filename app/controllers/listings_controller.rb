class ListingsController < ApplicationController

  include RequestPath
    
  caches_page :index, :show,
    :if => Proc.new { |c| c.request_path_parts.first == 'real_estate' }
  
  def gen_times(factor)
     return Proc.new {|n| n*factor }
   end
   
  before_filter :set_search_params
  
  def index
    # Record user's search results for the most recent listings index they
    # have viewed
    session[:last_seen_params] = search_params
        
    # Searchlogic filtering
    unless active_agency.master_agency
      unless order_scope
        @search = active_agency.listing.search( search_params )
      else
        @search = active_agency.listing.send(order_scope).search(
          search_params )
      end
    else
      unless order_scope
        @search = Listing.regular_index.search( search_params )
      else
        @search = Listing.regular_index.send(order_scope).search(
          search_params )
      end
    end
    @listings = @search.paginate( :page => params[:page ] )
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

  def show
    @listing = Listing.find(params[:id])
    # User might send information request
    if session[:information_request] # Load data from session after redirect
      @information_request = session[:information_request]
      session.delete(:information_request)
    else
      @information_request = InformationRequest.new
    end
    add_recent_listing(@listing) # remember listings seen
  end
  
  # AJAX target for listing image swap for glider images
  def glider_image_swap
    image = PropertyImage.find(params[:image_id])
    render :partial => 'glider_image_swap',
      :layout => false,
      :locals => { :image => image }
  end


  private
  
  def order_field
    return if params[:order].blank?
    params[:order].split(' ').first
  end
  
  def order_direction
    return if params[:order].blank?
    direction = params[:order].split(' ').last
    unless direction.blank?
      direction.upcase!
      direction = 'ASC' unless direction.index(/ASC|DESC/)
    else
      direction = 'ASC'
    end
    return direction
  end
  
  def order_scope
    return unless order_field
    case order_direction.downcase
    when 'desc'
      scope = 'descend_by'
    else # 'asc'
      scope = 'ascend_by'
    end
    "#{scope}_#{order_field}"
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
    # TODO: figure out how to do this without having to change params to symbols
    symbolic_params = {}
    search_params.each_pair do |key, value|
      symbolic_params.merge!(key.to_sym => value)
    end
    @search_params = symbolic_params
  end
end
