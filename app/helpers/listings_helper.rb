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
    params_to_title( true )
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
    location_text << barrio.canton.name if barrio.canton
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
  def listing_contact( listing = nil )
    listing = @listing unless listing
    if listing.property
      if listing.property.agency
        if listing.property.agency.broker
          contact = listing.property.agency.broker
        end
      end
    end
    unless contact
      contact = Agent.find( :first,
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
    image_html = image_tag thumb_images_property_image_path( image,
      :format => :jpg)
    if link
      html = link_to image_html, fullsize_images_property_image_path( image ),
        :target => :image_viewer
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
    types = [
      {
        :label => 'for sale',
        :cached_slug => 'for-sale'
      },
      {
        :label => 'rentals',
        :cached_slug => 'for-rent'
      }
    ]
    if @search_params[ LISTING_TYPE_EQUALS ]
      type = @search_params[ LISTING_TYPE_EQUALS ]
    else
      type = 'for-sale'
    end
    if type == 'for-rent'
      active_type_index = 1
    else
      active_type_index = 0
    end
    parts = []
    (0..1).each do |index|
      if index == active_type_index
        parts[index] = types[index][:label]
      else
        parts[index] = link_to(types[index][:label],
          listings_options(
            @search_params.merge(
              LISTING_TYPE_EQUALS => types[index][:cached_slug]
            )
          )
        )
      end
    end
    parts.join(' <span>|</span> ')
  end
  
  def category_filter
    if @search_params[CATEGORIES_EQUALS_ANY]
      has_filter = true
    end
    if has_filter
      html = '<ul><li>' +
        link_to('All categories', listings_options(
          @search_params.merge(CATEGORIES_EQUALS_ANY => nil)
        )) + '</li></ul>'
    else
      # TODO: select subset of records associated with current listings
      if @search_params[LISTING_TYPE_EQUALS]
        conditions = nil
        if @search_params[LISTING_TYPE_EQUALS] == 'for-sale' ||
          @search_params[LISTING_TYPE_EQUALS] == 'for-rent'
          conditions = [
            'listing_types.cached_slug = ?',
            @search_params[LISTING_TYPE_EQUALS]
          ]
        end
        categories = Category.find(:all,
          :joins => :listing_types,
          :conditions => conditions
        )
      end
      unless categories
        categories = Category.find(:all,
          :joins => { :category_assignments => :listing_types }
        )
      end
      return if categories.empty?
      html = get_highlighted_html( categories, :form )
    end
    return unless html
    "<div class=\"menu_list\"><h3>Filter by category</h3>#{html}</div>"
  end
  
  def style_filter
    if @search_params[STYLES_EQUALS_ANY]
      has_filter = true
    end
    if has_filter
      html = '<ul><li>' +
        link_to('All styles', listings_options(
          @search_params.merge(STYLES_EQUALS_ANY => nil)
        )) + '</li></ul>'
    else
      # TODO: select subset of records associated with current listings
      if @search_params[LISTING_TYPE_EQUALS]
        styles = Style.find(:all,
          :joins => :listing_types,
          :conditions => [
            'listing_types.cached_slug = ?',
            @search_params[LISTING_TYPE_EQUALS]
          ]
        )
      end
      unless styles
        styles = Style.all
      end
      return if styles.empty?
      html = get_highlighted_html( styles )
    end
    return unless html
    "<div class=\"menu_list\"><h3>Filter by style</h3>#{html}</div>"
  end
  
  def feature_filter
    if @search_params[FEATURES_EQUALS_ANY]
      has_filter = true
    end
    if has_filter
      html = '<ul><li>' +
        link_to('All features', listings_options(
          @search_params.merge(FEATURES_EQUALS_ANY => nil)
        )) + '</li></ul>'
    else
      # TODO: select subset of records associated with current listings
      if @search_params
        if @search_params[LISTING_TYPE_EQUALS]
          features = Feature.find(:all,
            :joins => [:listing_types, :feature_assignments],
            :conditions => [
              'listing_types.cached_slug = ?' +
                ' AND feature_assignments.highlighted = 1',
              @search_params[LISTING_TYPE_EQUALS]
            ]
          )
        end
      end
      unless features
        features = Feature.find(:all,
          :include => { :listing_types => :feature_assignments },
          :conditions => 'feature_assignments.highlighted = 1')
      end
      return if features.empty?
      html = get_highlighted_html( features, :form )
    end
    return unless html
    "<div class=\"menu_list\"><h3>Filter by feature</h3>#{html}</div>"
  end
  
  def place_filter( type )
    parents = []
    places = [ :country, :zone, :province, :market, :canton, :barrio ]    
    case type
    when :country
    when :zone
      parents = [ :country ]
    when :province
      parents = [ :country ]
    when :market
      parents = [ :country ]
    when :canton
      parents = [ :zone, :province ]
    when :barrio
      parents = [ :market, :canton ]
    end
    place_equals = "#{type.to_s.upcase}_EQUALS".constantize
    if @search_params[place_equals]
      nil_params = {}
      in_scope = false
      places.each do |place|
        in_scope = true if place == type
        if in_scope
          key = "#{place.to_s.upcase}_EQUALS".constantize
          nil_params.merge!( key => nil )
        end
      end
      
      html = '<li>' +
        link_to("All #{type.to_s.pluralize}", listings_options(
          @search_params.merge( nil_params )
        )) + '</li>'
    else
      required_search_params = []
      parents.each do |parent|
        required_search_params << [
          parent,
          "#{parent.to_s.upcase}_EQUALS".constantize
        ]
      end
      filtered_parents = []
      required_search_params.each do |param|
        if @search_params.include?(param[1])
          filtered_parents << param[0]
        end
      end
      return if filtered_parents.empty? && type != :country
      case type
      when :country
        conditions = { :active => true }
      when :zone, :province, :market
        joins = :country
        conditions = [
          'countries.cached_slug = :country',
          { :country => params[COUNTRY_EQUALS] }
        ]
      when :canton
        joins = { :province => :country }
        conditions = [
          'countries.cached_slug = :country' +
            ' AND provinces.cached_slug = :province',
          {
            :country => params[COUNTRY_EQUALS],
            :province => params[PROVINCE_EQUALS]
          }
        ]
      when :barrio
        joins = { :canton => { :province => :country } }
        conditions = [
          'countries.cached_slug = :country' +
            ' AND provinces.cached_slug = :province' +
            ' AND cantons.cached_slug = :canton',
          {
            :country => params[COUNTRY_EQUALS],
            :province => params[PROVINCE_EQUALS],
            :canton => params[CANTON_EQUALS]
          }
        ]
      end
      if type == :market && ! @active_agency.master_agency?
        places = @active_agency.markets
      else
        unless @active_agency.master_agency?
          if type == :canton || type == :barrio
            market_ids =
              @active_agency.markets.map { |market| market.id }.join(',')
            conditions << [
              'markets.id IN :markets',
              { :markets => market_ids }
            ]
          end
        end
        places = "#{type.to_s.camelize}".constantize.find( :all,
          :joins => joins,
          :conditions => conditions
        )
      end
      return if places.empty?
      html = ''
      places.each do |place|
        place_params = { place_equals => place.cached_slug }
        parents.each do |parent|
          if place.send("#{parent.to_s}")
            place_params.merge!(
              "#{parent.to_s.upcase}_EQUALS".constantize =>
                place.send("#{parent.to_s}").cached_slug
            )
          end
        end
        html += '<li>' +
          link_to(place.name.titleize, listings_options(
            @search_params.merge( place_params )
          )) + '</li>'
      end
    end
    return unless html
    "<div class=\"menu_list\"><h3>Filter by #{type}</h3><ul>" + html +
      '</ul></div>'
  end
  
  def price_range_filter
    if @search_params[ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO] ||
    @search_params[ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO]
      has_filter = true
    end
    if has_filter
      html = '<li>' +
        link_to('Any price', listings_options(
          @search_params.merge(
            ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO => nil,
            ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO => nil
          )
        )) + '</li>'
      html = '<div class="menu_list"><h3>Filter by price range' + '</h3><ul>' +
        html + '</ul></div>'
    else
      if @search_params[LISTING_TYPE_EQUALS]
        listing_type = @search_params[LISTING_TYPE_EQUALS]
        if listing_type == 'for-sale' || listing_type == 'for-rent'
          listing_types = [ listing_type.gsub(/-/, ' ') ]
        end
      end
      unless listing_types
        listing_types = [ 'for sale', 'for rent' ]
      end
      html = ''
      listing_types.each do |listing_type|
        list_items = ''
        PRICE_RANGES[listing_type].each do |price_range|
          boundaries = {}
          unless price_range[:lower].zero?
            boundaries.merge!(
              ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO => price_range[:lower].to_s)
          end
          if price_range[:upper]
            boundaries.merge!(
              ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO => price_range[:upper].to_s)
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
    return unless html
    html
  end
  
  def get_highlighted_html( collection, type = :links )
    return if collection.empty?
    model_name = collection[0].class.class_name.underscore
    case type
    when :form
      parent_tag_type = :form
      child_tag_type = :input
    else
      parent_tag_type = :ul
      child_tag_type = :li
    end
    highlighted = []
    normal = []
    min = 5
    if collection.length <= min
      highlighted = collection
    else
      collection.each_with_index do |record, i|
        if i < min || record.send("#{model_name}_assignments")[0].highlighted
          highlighted << record
        else
          normal << record
        end
      end
    end
    highlighted_html = normal_html = ''
    highlighted.each do |record|
      highlighted_html += item_for_list( record, child_tag_type )
    end
    normal.each do |record|
      normal_html += item_for_list( record, child_tag_type )
    end
    if highlighted_html
      html = highlighted_html
      unless normal_html.blank?
        normal_id = 'normal_' + model_name.to_s + '_filter'
        html += "<div class=\"more\"" +
          " onclick=\"$j(this).hide();$j('##{normal_id}').show('blind')\"" +
          " id=\"more_#{model_name.to_s.pluralize}_trigger\">more...</div>\n" +
          "<div style=\"display: none\"" +
          " class=\"normal\" id=\"#{normal_id}\">#{normal_html}</div>\n"
      end
    end
    return if html.blank?
    case type
    when :form
      html = "<form>#{html}</form>"
      form_inner_html = text_field_tag(
          "#{model_name.to_s.pluralize.upcase}_EQUALS_ANY".constantize.to_s,
          nil,
          :style => 'display: none'
        ) + "\n" + submit_tag('Filter') + "\n"
      html += form_tag( listings_path, :method => :get ) do |form|
        form_inner_html
      end
    else
      content_tag( parent_tag_type, html + "\n" )
    end
  end
  
  
  private
  
  def item_for_list( object, type, escape = true )
    model_name = object.class.class_name.underscore
    named_route = "#{model_name.to_s.pluralize.upcase}_EQUALS_ANY".constantize
    label = object.name.capitalize
    name = named_route.to_s + '[]'
    value = object.cached_slug
    id = model_name + '_' + value
    case type
    when :li
      content = content_tag( type, link_to(label,
          listings_options(
            @search_params.merge(
              named_route => object.cached_slug
            )
          )
        )
      )
    when :input
      content = label_tag(id, label) + "\n" +
        check_box_tag(name, value, nil, :id => id,
          :onclick => "updateCheckedValues('#{named_route.to_s})'") + "\n"
    end
  end
end
