class ListingsController < ApplicationController
  
  #caches_page :large_glider
  
  # GET /listings
  # GET /listings.xml
  def index
    # Record querystring in session so we can return to these results
    session[:last_seen_params] = params_with_maximum_readability
    
    # Searchlogic filtering
    unless active_agency.master_agency
      @search = Listing.by_agency(active_agency.id).search(
        combined_search_params)
    else
      @search = Listing.search(combined_search_params)
    end
    
    @listings = @search.paginate :page => params[:page], :order => infer_order
    #@listings = @search
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @listings }
    end
  end
  
#  # GET /listings/large_glider
#  def featured_glider
#    unless active_agency.master_agency
#      @featured_listings = Listing.by_agency(active_agency.id).featured
#      # Prepend agency to collection of listings so that the first group of
#      # images to appear in the glider are agency images
#      @featured_listings = @featured_listings.insert(0, active_agency)
#    else
#      @featured_listings = Listing.featured
#    end
#  end

  # GET /listings/1
  # GET /listings/1.xml
  def show
    @listing = Listing.find(params[:id])

    # User might send information request
    @information_request = InformationRequest.new

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
  
  def infer_order
    direction = ''
    unless params[:order_dir].blank?
      direction = ' ' + params[:order_dir]
    end
    return params[:order] + direction unless params[:order].blank?
    # TODO: create scheme to change order of listings so that the same listings
    # don't always show up at the top of the list
    if combined_search_params.has_key?('property_barrio_country_name_equals')
      if combined_search_params.has_key?('categories_name_equals')
        if combined_search_params.has_key?('property_barrio_market_name_equals')
          if combined_search_params.has_key?('property_barrio_name_equals')
            order = 'listings.ask_amount'
          else
            order = 'barrios.name, listings.ask_amount'
          end
        else
          order = 'markets.name, barrios.name'
        end
      else
        if combined_search_params.has_key?('property_barrio_market_name_equals')
          if combined_search_params.has_key?('property_barrio_name_equals')
            order = 'categories.name'
          else
            order = 'categories.name, barrios.name'
          end
        else
          order = 'markets.name, barrios.name'
        end
      end
    else
      if combined_search_params.has_key?('categories_name_equals')
        order = 'countries.name, markets.name, barrios.name'
      else
        order = 'listings.ask_amount'
      end
    end
    order = 'listings.created_at DESC' unless order
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
  
  # Integrate explicit searchlogic params into readable string and append
  # non-readable searchlogic params. This is useful when performing advanced
  # searches where the user introduces seach parameters that can be rewritten
  # so as to avoid pagination and navigation links with unwieldy urls.
  # Example:
  #   http://barrioearth-dev.com:3000/real_estate?search=all--property--for+sale
  #     &q[property_barrio_country_name_equals]=Costa+Rica
  #     &q[categories_name_equals]=Hotels
  # would be rewritten:
  #   http://barrioearth-dev.com:3000/real_estate?search=Costa-Rica--Hotels--
  #     for+sale
  def params_with_maximum_readability
    new_params = params.dup
    return new_params unless combined_search_params # No searchlogic params
    # Extract readable and non-readable params from combined search params
    # so that any searchlogic params that *can* be integrated into readable
    # string are thusly converted
    readable_string, non_readable_params =
      searchlogic_params_to_readable_params(combined_search_params)
    # Get rid of un-normalized readable string + searchlogic params... 
    new_params.delete(:q)
    new_params.delete(:search)
    # ...and replace with more readable version
    unless readable_string.blank?
      new_params.merge!(:search => readable_string)
    end
    unless non_readable_params.empty?
      new_params.merge!(:q => non_readable_params)
    end
    return new_params
  end
end
