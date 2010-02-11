# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  # Module for translating search parameters into readable string and back again
  include ContextResources
  include HostHelp
  include ReadableSearch
  
  #helper :all # include all helpers, all the time
  helper :layout
  
  # 2009-03-04 - Brian Warren - Authlogic stuff
  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation
  
  protect_from_forgery # See ActionController::RequestForgeryProtection

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  before_filter :set_page_caching_status, :set_active_agency,
    :set_agency_content, :redirect_if_current_agency_not_found, :set_locale,
    :glide_image_pairs, :set_combined_search_params,
    :clean_params_for_searchlogic
  

  private
  
  # Need variable in view to know if caching is enabled. Used to save
  # javascript into cached page so that certain dynamic things are handled by
  # client-side javascript since Rails is skipped when page caching is on
  # TODO: better way?
  def set_page_caching_status
    if perform_caching && caching_allowed
      @page_caching_active = true
    else
      @page_caching_active = false
    end
  end
  
  #
  # Locale-related methods
  #
  # Get locale from TLD (last part of domain name) - easiest to implement and
  # best for search engines. Downside is you have to own this domain name
  def set_locale
    I18n.locale = extract_locale_from_tld
  end
  # Get locale from top-level domain or return nil if such locale is not available
  # You have to put something like:
  #   127.0.0.1 application.com
  #   127.0.0.1 application.it
  #   127.0.0.1 application.pl
  # in your /etc/hosts file to try this out locally
  def extract_locale_from_tld
    parsed_locale = request.host.split('.').last
    (I18n.available_locales.include? parsed_locale) ? parsed_locale : nil
  end
  
  ##
  # "cache_page" alias method which effectivly forces the domain name to be
  # pre-pended to the page cache path. Note that the "caches_page" method
  # called on actions within a controller is affected by this as well
  def cache_page_with_domain(content = nil, options = nil)
    return unless perform_caching && caching_allowed
    
    path = "/#{request.host}"
    path << case options
      when Hash
        url_for(options.merge(:only_path => true,
          :skip_relative_url_root => true, :format => params[:format]))
      when String
        options
      else
        if request.path.empty? || request.path == '/'
          '/index'
        else
          request.path
        end
    end

    cache_page_without_domain(content, path)
  end
  alias_method_chain :cache_page, :domain
  
  #
  # Active agency
  #
  def active_agency
    order_parts = []
    if current_domain
      order_parts << "agencies.domain = '" + intended_domain(current_domain) +
        "' DESC"
    end
    if current_subdomain
      order_parts << "agencies.subdomain = '" + current_subdomain + "' DESC" 
    end
    order_parts << "agencies.master_agency = 1 DESC"
    order_parts << "agencies.id ASC"
    order = order_parts.join(', ')
    Agency.find(:first,
      :include => {
        :properties => :listings,
        :broker => { :user => :user_icons }
      },
      :order => order
    )
  end
  
  def set_active_agency
    @active_agency = active_agency
  end
  
  # Redirect to known agency for current domain
  # NOTE: Hostnames that are not associated with an agency record (such as
  # localhost, IP addresses, and other hostnames that happen to resolve to the
  # server) are not redirected and result in the default agency record being
  # used as the "active agency". This makes it so developers can test basic
  # functionality without having to set up name resolution in /etc/hosts.
  def redirect_if_current_agency_not_found
    return unless active_agency
    # Redirect if current domain and subdomain don't match record
    if intended_domain(current_domain) == active_agency.domain
      if (current_subdomain || "") != active_agency.subdomain
        unless active_agency.subdomain.blank?
          redirect_subdomain = active_agency.subdomain
        else
          redirect_subdomain = nil
        end
        redirect_to root_url(:subdomain => redirect_subdomain)
      end
      # NOTE: if domain doesn't match, then continue with current value for
      # active agency, which will be the master agency with the smallest id
    end
  end
  
  # Load site texts data from database into key/value pair array
  def agency_content
    content = {}
    if active_agency.site_texts
      active_agency.site_texts.each do |site_text|
        content.merge!(site_text.name.to_sym => site_text.value)
      end
    end
    return content
  end
  
  def set_agency_content
    @agency_content = agency_content
  end
  
# REMOVED - using SubdomainFu plugin instead  
#  def extract_agency_from_subdomain
#    parsed_agency = request.subdomains.first
#  end
  
  # Handle nested actions
  def context_object( *finder_options )
    params[:context_type].classify.constantize.find( context_id, *finder_options )
  end
  
  def context_id
    params["#{ params[:context_type].singularize }_id"]
  end
  
  # Authlogic methods
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  # Expire cached image
  def expire_image(image)
    expire_page polymorphic_path(image, :format => :jpg)
  end
  
  # Merge Property Images with Listing Images
  def merge_images(listing)
    listing.images = listing.property_images.dup
    unless listing.property.blank?
      unless listing.property.property_images.blank?
        unless listing.images.blank?
          listing.images += listing.property.property_images
        else
          listing.images = listing.property.property_images
        end
      end
    end
  end

  # Get images for glide utility
  def glide_image_pairs
    @glide_image_pairs = []
    listings = Listing.find(:all)
    pair_offset = 0
    listings.each do |listing|
      merge_images(listing)
      if listing.images.length > 1
        pair = []
        listing.images.each_with_index do |image, j|
          pair << image
          pair_offset = pair_offset + 1
          #break if j # only load 2 images at a time into array
        end
        @glide_image_pairs << pair
      end
    end
    return @glide_image_pairs
  end
  
  # allow "friendly_id" - lookup actual id from slug
  def real_id(model_name, friendly_id)
    if friendly_id.to_s.to_i == 0
      obj = model_name.constantize.find(friendly_id)
      if obj
        return obj.id
      end
    end
    friendly_id
  end
  
  # Combine readable constraints and searchlogic constraints
  def set_combined_search_params
    @combined_search_params = combined_search_params
  end
  
  def combined_search_params
    readable_string_to_searchlogic_params( params[:search] || '' ).merge!(
      params[:q] || {} )
  end
  
  # http://rails.barrioearth.com/real_estate/search/all/property/for+sale+or+rent/any+market/any+barrio/under+any+amount/over+any+amount/any+style/any+feature
  # http://rails.barrioearth.com/real_estate/search/Costa+Rica/Homes/for+sale/Heredia/Santo+Domingo/under+500000+dollars/over+250000+dollars/modern/beach+home,pool
  
  # Remove extraneous words from global params so that it reflects the intended
  # values of a verbose URL
  def clean_params_for_searchlogic
    params = @sparse_params
  end
  
  # Sanitize searchlogic params by removing strings indicating default_value and
  # removing extraneous words that are not actually part of the lookup value
  # (reverse of "ApplicationHelpter::verbose_params")
  def sparse_params(parameters = nil)
    if parameters.nil?
      parameters = params.dup
    end
    LISTING_PARAMS_MAP.each do |param|
      if parameters[param[:key]]
        if parameters[param[:key]] == default_value
          parameters[param[:key]] = nil
        else
          case key
            # Slice off "under " and " dollars"
            when :ask_amount_less_than_or_equal_to
              parameters[param[:key]] = parameters[
                param[:key]].slice(6..-1).slice(0..-9)
            # Slice off "over " and " dollars"
            when :ask_amount_greater_than_or_equal_to
              parameters[param[:key]] = parameters[
                param[:key]].slice(5..-1).slice(0..-9)
          end
        end
      end
    end
    return parameters
  end
end
