module ListingsHelper

  include PropertiesHelper
  include UnitConversionHelper
  
  def contextual_listing_path( record_or_hash, options = {} )
    if request_path_parts.first == 'real_estate'
      real_estate_path( record_or_hash, options )
    else
      listing_path( record_or_hash, options )
    end
  end
  
  def contextual_listings_path( record_or_hash, options = {} )
    if request_path_parts.first == 'real_estate'
      real_estates_path( record_or_hash )
    else
      listings_path( record_or_hash )
    end
  end
  
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
        feature_list += '<li>' + h(feature.name).capitalize + '</li>' + "\n"
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
        :conditions => { :agents => { :id => 1 } }
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
      link_to(image_html, contextual_listing_path(listing))
    end
  end
  
  def room_number_select( type )
    room_number_param = "#{type.to_s.upcase}_NUMBER".constantize
    selected_comparator = ''
    selected_integer = ''
    if params[room_number_param]    
      result = room_comparator_and_number_from_string( type,
        params[room_number_param] )
      selected_comparator, selected_number = result if result
    end
    select_tag( "#{type}_number_comparator".to_sym,
      options_for_select(
        [['don\'t specify', ''], ['at least', 'at-least'],
          ['exactly', 'exactly'], ['no more than', 'no-more-than'] ],
        selected_comparator
      ),
      :class => "#{type}_select" ) +
    select_tag( "#{type}_number_integer".to_sym,
      options_for_select([''] + (1..6).map, selected_number),
      :class => "#{type}_select" ) +
    label_tag( "#{type}_number_comparator".to_sym,
      "#{type.to_s.pluralize}" )
  end
  
  def bedroom_number_select
    room_number_select( :bedroom )
  end
  
  def bathroom_number_select
    room_number_select( :bathroom )
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
        :conditions => conditions,
        :order => filter_order_clause(:category)
      )
    end
    unless categories
      categories = Category.find(:all,
        :joins => :listing_types,
        :order => filter_order_clause(:category)
      )
    end
    return if categories.empty?
    html = filter_field_list( categories, :form )
    return unless html
    "<div class=\"menu_list\"><h3>Filter by category</h3>#{html}</div>"
  end
  
  def feature_filter
    # TODO: select subset of records associated with current listings
    if @search_params
      if @search_params[LISTING_TYPE_EQUALS]
        features = Feature.find(:all,
          :joins => :listing_types,
          :conditions => [
            'listing_types.cached_slug = ?',
            @search_params[LISTING_TYPE_EQUALS]
          ],
          :order => filter_order_clause(:feature)
        )
      end
    end
    unless features
      features = Feature.find(:all,
        :joins => :listing_types,
        :order => filter_order_clause(:feature)
      )
    end
    return if features.empty?
    html = filter_field_list( features, :form )
    return unless html
    "<div class=\"menu_list\"><h3>Filter by feature</h3>#{html}</div>"
  end
  
  def style_filter
    # TODO: select subset of records associated with current listings
    if @search_params[LISTING_TYPE_EQUALS]
      styles = Style.find(:all,
        :joins => :listing_types,
        :conditions => [
          'listing_types.cached_slug = ?',
          @search_params[LISTING_TYPE_EQUALS]
        ],
        :order => filter_order_clause(:style)
      )
    end
    unless styles
      styles = Style.find(:all,
        :joins => :listing_types,
        :order => filter_order_clause(:style)
      )
    end
    return if styles.empty?
    html = filter_field_list( styles, :form )
    return unless html
    "<div class=\"menu_list\"><h3>Filter by style</h3>#{html}</div>"
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
      conditions = { :countries => { :active => true } }
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
    html = any_place_html = ''
    places.each do |place|
      if @search_params[place_equals]        
        any_place_html = '<li>' +
          link_to("All #{type.to_s.pluralize}",
            listings_options(
              @search_params.merge(
                "#{type.to_s.upcase}_EQUALS".constantize => nil ) ) ) + '</li>'
      end
      # Skip currently-selected place
      next if @search_params[place_equals] == place.friendly_id
      place_params = { place_equals => place.cached_slug }
      parents.each do |parent|
        if place.send("#{parent.to_s}")
          place_params.merge!(
            "#{parent.to_s.upcase}_EQUALS".constantize =>
              place.send("#{parent.to_s}").friendly_id
          )
        end
      end
      html += '<li>' +
        link_to(place.name.titleize, listings_options(
          @search_params.merge( place_params )
        )) + '</li>'
    end
    return unless html
    html = any_place_html + html
    "<div class=\"menu_list\"><h3>Filter by #{type}</h3><ul>" + html +
      '</ul></div>'
  end
  
  def price_range_filter
    if @search_params[LISTING_TYPE_EQUALS]
      param_listing_type = @search_params[LISTING_TYPE_EQUALS]
      if param_listing_type == 'for-sale' || param_listing_type == 'for-rent'
        listing_types = [ param_listing_type.gsub(/-/, ' ') ]
      end
    end
    unless listing_types
      listing_types = [ 'for sale', 'for rent' ]
      param_listing_type = 'for-sale-or-rent'
    end
    
    html = ''
    # TODO: why doesn't this match a shorter route?
    if @search_params[ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO] ||
      @search_params[ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO]
      any_price_range_html = '<li>' +
        link_to('Any price range', listings_options(
          @search_params.merge(LISTING_TYPE_EQUALS => 'for-sale-or-rent',
            ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO => nil,
            ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO => nil
          )
        )) + '</li>'
    else
      any_price_range_html = ''
    end
    listing_types.each_with_index do |listing_type, i|
      list_items = ''
      PRICE_RANGES[listing_type].each do |price_range|
        boundaries = { LISTING_TYPE_EQUALS => param_listing_type }
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
      list_items = any_price_range_html + list_items
      header = 'Filter by price range'
      if listing_types.length > 1
        if listing_type == 'for sale'
          header += ' (for sale)'
        else
          header += ' (rentals)'
        end
      end
      html += "<h3>#{header}</h3>" + '<ul>' + list_items + '</ul>'
    end
    return unless html
    
    "<div class=\"menu_list\">#{html}</div>"
  end
  
  def filter_field_list( collection, type = :links )
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
    fields_html = fields = {
      :highlighted => [],
      :normal => []
    }
    min = 5
    if collection.length <= min
      fields[:highlighted] = collection
    else
      collection.each_with_index do |record, i|
        if i < min ||
        cached_slug_array( model_name ).include?( record.friendly_id ) ||
        record.send("#{model_name}_assignments")[0].highlighted
          fields[:highlighted] << record
        else
          fields[:normal] << record
        end
      end
    end
    fields.each_pair do |key, records|
      fields_html[key] = ''
      records.each do |record|
        fields_html[key] += item_for_list( record, child_tag_type )
      end
    end
    if fields_html
      html = fields_html[:highlighted]
      unless fields_html[:normal].blank?
        normal_id = 'normal_' + model_name.to_s + '_filter'
        html += %Q{
<div class=\"more\"
onclick=\"$j(this).hide();$j('##{normal_id}').show('blind')\"
id=\"more_#{model_name.to_s.pluralize}_trigger\">more...</div>\n
<div style=\"display: none\"
class=\"normal clearfix\" id=\"#{normal_id}\">
  #{fields_html[:normal]}
  <div class=\"more\"
  onclick=\"$j('#more_#{model_name.to_s.pluralize}_trigger').show();
    $j('##{normal_id}').hide('blind')\"
  id=\"show_#{model_name.to_s.pluralize}_trigger\">less...</div>\n
</div>\n
        }
      end
    end
    return if html.blank?
    case type
    when :form
      html += '<div class="submit_row">' + submit_tag('Filter') + "</div>\n"
      content_tag( parent_tag_type, html + "\n", :class => 'multiple_filter' )
    else
      content_tag( parent_tag_type, html + "\n" )
    end
  end
  
  def filter_form( id = 'filter_form' )
    html = '<form id="' + id +'" action="" method="get">' + "\n"
    SEARCH_PARAMS_MAP.each do |pair|
      key = pair[:key]
      unless value = params[key]
        value = pair[:null_equivalent][0]
      end
#      html += label_tag(key, key.to_s) + text_field_tag(
      html += hidden_field_tag(
        key,
        value,
        { :style => 'display: block' }
      ) + "\n"
    end
    html += '</form>' + "\n"
  end
  
  
  private
  
  def item_for_list( object, type, options = {} )
    model_name = object.class.class_name.underscore
    if model_name == 'feature'
      # TODO: figure out how to select only records where ALL values can be
      # found in related table.
      inclusiveness = 'ALL'
    else
      inclusiveness = 'ANY'
    end
    model_capitalized = model_name.to_s.pluralize.upcase
    scope_name = "#{model_capitalized}_EQUALS_#{inclusiveness}".constantize
    label = object.name.capitalize
    name = scope_name.to_s + '[]'
    value = object.friendly_id
    id = model_name + '_' + value
    case type
    when :li
      content = content_tag( type, link_to(label,
          listings_options(
            @search_params.merge(
              scope_name => object.friendly_id
            )
          )
        )
      )
    when :input
      if params[scope_name]
        selected = params[scope_name].include?(value) ? true : false
      end
      options.merge!( :id => id )
      content = '<div class="row clearfix">' + "\n" +
        check_box_tag(name, value, selected, :id => options[:id],
          :onclick => "updateCheckedValues(this.id" +
            ", '#{scope_name.to_s}')") + label_tag(id, label) + "\n" +
        '</div>' + "\n"
    end
  end
  
  def filter_order_clause( model_name )
    table = model_name.to_s.tableize
    order = []
    unless cached_slug_string( model_name ).blank?
      order << "#{table}.cached_slug IN" +
        " (#{cached_slug_string( model_name )}) DESC"
    end
    order << "#{model_name}_assignments.highlighted DESC"
    order << "#{table}.name"
    order.join(', ')
  end
  
  def cached_slug_string( model_name )
    cached_slug_array( model_name ).map { |slug| "'#{slug}'" }.join(',')
  end
  
  def cached_slug_array( model_name )
    if model_name.to_s == 'feature'
      inclusiveness = 'ALL'
    else
      inclusiveness = 'ANY'
    end
    model_capitalized = model_name.to_s.pluralize.upcase
    scope_name = "#{model_capitalized}_EQUALS_#{inclusiveness}".constantize
    if search_params[scope_name]
      search_params[scope_name].map { |param| param }
    else
      []
    end
  end
end
