module ListingsHelper

  include PropertiesHelper
  include UnitConversionHelper
  
  # Convert searchlogic search params to a formatted, readable title
  def params_to_title(add_linebreaks = true)
    text = ''
    unless @search_params.empty?
      text = searchlogic_params_to_readable_params(@search_params, 'text',
        add_linebreaks)[0]
      text = text[0..0].upcase + text[1..-1]
    else
      text = 'All listings'
    end
  end
  
  # Set up <title> tag from searchlogic params
  def index_title
    params_to_title(false)
  end
  
  # Set up page header from searchlogic params
  def page_header
    params_to_title(true)
  end
  
  def show_title
    return if @listing.name.blank?
    title = @listing.name
    title += ' ' + primary_category unless primary_category.blank?
    if @listing.property.barrio
      title += ' in ' +  location_formatted( @listing.property.barrio ) +
        ', ' + @listing.property.barrio.canton.province.country.name
    end
  end
  
  def primary_category(listing = nil)
    listing = @listing unless listing
    if listing
      unless listing.categories.empty?
        primary_category = listing.categories[0].name.singularize
      end
    end
    primary_category || ''
  end
  
  def primary_style(listing = nil)
    listing = @listing unless listing
    primary_style = listing.styles[0].name unless listing.styles.empty?
    return primary_style || ''
  end
  
  def price_formatted(amount, symbol, code)
    return '' unless amount
    class_attr = ' class="price "' + code.to_s.downcase
    return number_to_currency(
      amount,
      :unit => symbol,
      :precision => 0
    ) + ' ' + code.to_s
  end

  def price_div( listing = nil )
    listing = @listing unless listing
    if listing.ask_amount.blank?
      return content_tag( :div, '', :class => 'price' )
    end
    amount = listing.ask_amount
    if listing.ask_currency
      symbol = listing.ask_currency.symbol
      code = listing.ask_currency.code
    else
      symbol = '$'
      code = 'USD'
    end
    #classes = 'price ' + code.to_s.downcase
    #return content_tag(:div, price(amount, symbol, code),
      #:class => classes)
    # TODO: find out if :class can accept array like this
    return content_tag(:div, price_formatted(amount, symbol, code),
      :class => ['price', ' ', code.to_s.downcase])
  end

  def location_formatted( barrio )
    location_text = []
    location_text << barrio.name
    location_text << barrio.market.name if barrio.market
    location_text.join(', ')
  end
  
  def ask_price( listing = nil )
    listing = @listing unless listing
    if listing.ask_currency
      symbol = listing.ask_currency.symbol
      code = listing.ask_currency.code
    else
      symbol = '$'
      code = 'USD'
    end
    price_formatted(listing.ask_amount, symbol, code)
  end

  def extra_features_inline(features)
    feature_list = ''
    if features
      features.each do |feature|
        feature_list += '<li>' + h(feature.name) + '</li>' + "\n\r"
      end
    end
    return feature_list || ''
  end
  
  def full_feature_list(listing = nil)
    listing = @listing unless listing
    full_feature_list = []
    unless primary_category.blank?
      full_feature_list << 'Category: ' + primary_category
    end
    if listing.property.barrio
      full_feature_list << 'Location: ' +
        location_formatted( listing.property.barrio )
    end
    unless ask_price.blank?
      full_feature_list << 'Ask price: ' + ask_price
    end
    unless main_feature_list(listing).empty?
      full_feature_list = full_feature_list + main_feature_list
    end
  end
  
  # TODO: get rid of this - too complex
    # TODO: need global contact hierarchy in case no broker provided
    # right now, just defaulting to user with id #1
  def listing_contact(listing = nil)
    listing = @listing unless listing
    contact = nil
    if listing.property
      if listing.property.agency
        if listing.property.agency.broker
          contact = listing.property.agency.broker
        end
      end
    end
    unless contact
      contact = Agent.find(:first,
        :include => { :user => :user_icons },
        :conditions => 'agents.id = 1'
      )
    end
    return contact
  end
  
  # TODO: get rid of this - too complex
  def agent_name(listing = nil)
    listing = @listing unless listing
    contact = listing_contact(listing)
    if contact
      if contact.user
        if contact.user.first_name && contact.user.last_name
          agent_name = contact.user.first_name.capitalize + ' ' +
            contact.user.last_name.capitalize
        else
          agent_name = contact.user.login
        end
      end
    end
    return agent_name || ''
  end
      
  def thumbnail(image, link = false)
    return if image.blank?
    image_html = image_tag(thumb_images_property_image_path(image,
      :format => :jpg))
    if link
      html = link_to(image_html, fullsize_property_image_path(image),
        :target => :image_viewer)
    else
      html = image_html
    end
  end
  
  def medium_image(image)
    unless image.blank?
      return image_tag(medium_images_property_image_path(image,
        :format => :jpg))
    end
  end
  
  def glider_image_swap(image, target_id)
    remote_function(
      :url => { :action => :glider_image_swap },
      :method => :get,
      :with => "'image_id=' + encodeURIComponent(" + image.id.to_s + ")",
      :before => "Element.show('main_image_spinner')",
      :complete => "Element.hide('main_image_spinner')",
      :update => target_id
    )
  end
  
  def main_image_spinner
    '<div id="main_image_spinner_wrapper">' +
      image_tag('ajax-loader.gif',
        :id => 'main_image_spinner',
        :style => "display: none"
      ) +
    '</div>'
  end
  
  def listing_thumbnail(image, listing = nil)
    return if image.blank?
    image_html = image_tag(thumb_images_property_image_path(image,
      :format => :jpg))
    # If listing object exists, link to listing view. Otherwise, link to a
    # larger version of image
    if listing.blank?
      link_to(image_html,
        images_property_image_path(image, :format => :html),
        :target => :image_viewer
      )
    else
      link_to(image_html, listing_path(listing))
    end
  end
  
  # Methods that make use of Searchlogic plugin
  # # # 
  def listing_type_toggle
    if @search_params[:listing_type_cached_slug_equals]
      current_type = @search_params[:listing_type_cached_slug_equals]
    else
      current_type = 'for sale'
    end
    if current_type == 'for sale'
      current_type + ' <span>|</span> ' +
      link_to('rentals', listings_options(
        :listing_type_cached_slug_equals => 'for-rent'))
    else
      link_to('for sale', listings_options(
        :listing_type_cached_slug_equals => 'for-sale')) + ' <span>|</span> ' +
          current_type
    end
  end
  
  def listing_type_filter
    if @search_params[:listing_type_cached_slug_equals]
      has_filter = true
    end
    if has_filter
      html = '<li>' +
        link_to('All listing types', listings_options(
          @search_params.merge(:listing_type_cached_slug_equals => nil)
        )) + '</li>'
    else
      # TODO: select subset of records associated with current listings
      listing_types = ListingType.all
      if listing_types
        html = ''
        listing_types.each do |listing_type|
          html += '<li>' +
            link_to(listing_type.name.capitalize, listings_options(
              @search_params.merge(
                :listing_type_cached_slug_equals => listing_type.cached_slug
              )
            )) + '</li>'
        end
      end
    end
    if html
      html = '<div class="menu_list"><h3>Filter by listing type</h3><ul>' +
        html + '</ul></div>'
    else
      html = ''
    end
  end
  
  def category_filter
    if @search_params[:categories_cached_slug_equals]
      has_filter = true
    end
    if has_filter
      html = '<li>' +
        link_to('All categories', listings_options(
          @search_params.merge(:categories_cached_slug_equals => nil)
        )) + '</li>'
    else
      # TODO: select subset of records associated with current listings
      if @search_params[:listing_type_cached_slug_equals]
        categories = Category.find(:all,
          :joins => :listing_types,
          :conditions => [
            'listing_types.name = ?',
            @search_params[:listing_type_cached_slug_equals]
          ]
        )
      end
      unless categories
        categories = Category.all
      end
      if categories
        html = ''
        categories.each do |category|
          html += '<li>' +
            link_to(category.name.capitalize, listings_options(
              @search_params.merge(
                :categories_cached_slug_equals => category.cached_slug
              )
            )) + '</li>'
        end
      end
    end
    if html
      html = '<div class="menu_list"><h3>Filter by category</h3><ul>' + html +
        '</ul></div>'
    else
      html = ''
    end
  end
  
  def style_filter
    if @search_params[:styles_cached_slug_equals]
      has_filter = true
    end
    if has_filter
      html = '<li>' +
        link_to('All styles', listings_options(
          @search_params.merge(:styles_cached_slug_equals => nil)
        )) + '</li>'
    else
      # TODO: select subset of records associated with current listings
      if @search_params[:listing_type_cached_slug_equals]
        styles = Style.find(:all,
          :joins => :listing_types,
          :conditions => [
            'listing_types.name = ?',
            @search_params[:listing_type_cached_slug_equals]
          ]
        )
      end
      unless styles
        styles = Style.all
      end
      if styles
        html = ''
        styles.each do |style|
          html += '<li>' +
            link_to(style.name.capitalize, listings_options(
              @search_params.merge(
                :styles_cached_slug_equals => style.cached_slug)
            )) + '</li>'
        end
      end
    end
    if html
      html = '<div class="menu_list"><h3>Filter by style</h3><ul>' + html +
        '</ul></div>'
    else
      html = ''
    end
  end
  
  def feature_filter
    if @search_params[:features_cached_slug_equals_any]
      has_filter = true
    end
    if has_filter
      html = '<li>' +
        link_to('All features', listings_options(
          @search_params.merge(:features_cached_slug_equals_any => nil)
        )) + '</li>'
    else
      # TODO: select subset of records associated with current listings
      if @search_params
        if @search_params[:listing_type_cached_slug_equals]
          features = Feature.find(:all,
            :joins => [:listing_types, :feature_assignments],
            :conditions => [
              'listing_types.name = ?' +
                ' AND feature_assignments.highlighted_feature = 1',
              @search_params[:listing_type_cached_slug_equals]
            ]
          )
        end
      end
      unless features
        features = Feature.find(:all,
          :include => { :listing_types => :feature_assignments },
          :conditions => 'feature_assignments.highlighted_feature = 1')
      end
      if features
        html = ''
        features.each do |feature|
          html += '<li>' +
            link_to(feature.name.capitalize, listings_options(
              @search_params.merge(
                :features_cached_slug_equals_any => feature.cached_slug)
            )) + '</li>'
        end
      end
    end
    if html
      html = '<div class="menu_list"><h3>Filter by feature</h3><ul>' + html +
        '</ul></div>'
    else
      html = ''
    end
  end
  
  def country_filter
    if @search_params[
      :property_barrio_canton_province_country_cached_slug_equals]
      has_filter = true
    end
    if has_filter
      html = '<li>' +
        link_to('All countries', listings_options(
          @search_params.merge(
            :property_barrio_canton_province_country_cached_slug_equals => nil,
            :property_barrio_market_cached_slug_equals => nil,
            :property_barrio_cached_slug_equals => nil
          )
        )) + '</li>'
    else
      countries = Country.find( :all, :conditions => { :active => true} )
      if countries
        html = ''
        countries.each do |country|
          html += '<li>' +
            link_to(country.name.capitalize, listings_options(
              @search_params.merge(
                :property_barrio_canton_province_country_cached_slug_equals =>
                  country.cached_slug
              )
            )) + '</li>'
        end
      end
    end
    if html
      html = '<div class="menu_list"><h3>Filter by country</h3><ul>' + html +
        '</ul></div>'
    else
      html = ''
    end
  end
  
  def market_filter
    if @search_params[:property_barrio_market_cached_slug_equals]
      html = '<li>' +
        link_to('All markets', listings_options(
          @search_params.merge(
            :property_barrio_market_cached_slug_equals => nil,
            :property_barrio_cached_slug_equals => nil
          )
        )) + '</li>'
    elsif @search_params[
      :property_barrio_canton_province_country_cached_slug_equals]        
      markets = []
      unless @active_agency.master_agency
        if @active_agency.markets
          @active_agency.markets.each do |market|
            # TODO: allow for non-standard characters
            if market.country.name.downcase == @search_params[
                :property_barrio_canton_province_country_cached_slug_equals
              ].downcase
              markets << market
            end
          end
        end
      else
        markets = Market.find(:all,
          :joins => :country,
          :conditions => [
            'countries.cached_slug = ?',
            params[:property_barrio_canton_province_country_cached_slug_equals]
          ]
        )
      end
      unless markets.empty?
        html = ''
        markets.each do |market|
          html += '<li>' +
            link_to(market.name.capitalize, listings_options(
              @search_params.merge(
                :property_barrio_market_cached_slug_equals => market.cached_slug
              )
            )) + '</li>'
        end
      end
    end
    if html
      html = '<div class="menu_list"><h3>Filter by market</h3><ul>' + html +
        '</ul></div>'
    else
      html = ''
    end
  end
  
  def barrio_filter
    if @search_params[:property_barrio_cached_slug_equals]
      html = '<li>' +
        link_to('All barrios', listings_options(
          @search_params.merge(:property_barrio_cached_slug_equals => nil)
        )) + '</li>'
    elsif @search_params[
      :property_barrio_canton_province_country_cached_slug_equals] &&
      @search_params[:property_barrio_market_cached_slug_equals]
      country_slug = @search_params[
        :property_barrio_canton_province_country_cached_slug_equals]
      market_slug = @search_params[
        :property_barrio_market_cached_slug_equals]
      barrios = Barrio.find(:all,
        :joins => [:market, :country],
        :conditions => [
          'countries.cached_slug = :x AND markets.cached_slug = :y', 
          {:x => country_slug, :y => market_slug}
        ]
      )
      if barrios
        html = ''
        barrios.each do |barrio|
          html += '<li>' +
            link_to(barrio.name.capitalize, listings_options(
              @search_params.merge(
                :property_barrio_cached_slug_equals => barrio.cached_slug)
            )) + '</li>'
        end
      end
    end
    if html
      html = '<div class="menu_list"><h3>Filter by barrio</h3><ul>' + html +
        '</ul></div>'
    else
      html = ''
    end
  end
  
  def price_range_filter
    if @search_params[:ask_amount_greater_than_or_equal_to] ||
    @search_params[:ask_amount_less_than_or_equal_to]
      has_filter = true
    end
    if has_filter
      html = '<li>' +
        link_to('Any price', listings_options(
          @search_params.merge(
            :ask_amount_greater_than_or_equal_to => nil,
            :ask_amount_less_than_or_equal_to => nil
          )
        )) + '</li>'
      html = '<div class="menu_list"><h3>Filter by price range' + '</h3><ul>' +
        html + '</ul></div>'
    else
      if @search_params[:listing_type_cached_slug_equals]
        listing_type = @search_params[:listing_type_cached_slug_equals]
        if listing_type == 'for sale' || listing_type == 'for rent'
          listing_types = [ listing_type ]
        end
      end
      unless listing_types
        listing_types = ['for sale', 'for rent']
      end
      html = ''
      listing_types.each do |listing_type|
        list_items = ''
        PRICE_RANGES[listing_type].each do |price_range|
          boundaries = {}
          unless price_range[:lower].zero?
            boundaries.merge!(
              :ask_amount_greater_than_or_equal_to => price_range[:lower].to_s)
          end
          if price_range[:upper]
            boundaries.merge!(
              :ask_amount_less_than_or_equal_to => price_range[:upper].to_s)
          end
          list_items += '<li>' +
            link_to(price_range[:label], listings_options(
              @search_params.merge(boundaries)
            )) + '</li>'
        end
        if listing_types.length > 1
          listing_type_label = ' (' + listing_type + ')'
        else
          listing_type_label = ''
        end
        html += '<div class="menu_list"><h3>Filter by price range' +
          listing_type_label + '</h3><ul>' + list_items + '</ul></div>'
      end
    end
    if html
      html
    else
      ''
    end
  end
end
