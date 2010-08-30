module ReadableSearch
  
  def self.included(base)
    base.module_eval do
      include ActionView::Helpers::NumberHelper
    end
  end
  
  # Prepare params for use with Searchlogic plugin by removing non-Searchlogic
  # elements, i.e. :controller, :action, :page, :order etc.
  def search_params( parameters = nil )
    if parameters.nil?
      parameters = params.dup
    end
    
    # Remove non-Searchlogic elements
    search_keys = SEARCH_PARAMS_MAP.map { |param| param[:key] }
    parameters.delete_if {
      |key, value| ! search_keys.include?( key.to_sym ) }
      
    return sanitize_search_params( parameters )
  end
  
  # Remove extraneous words that are not actually part of the lookup value
  def sanitize_search_params( parameters = nil )
    if parameters.nil?
      parameters = params.dup
    end
    SEARCH_PARAMS_MAP.each do |param|
      key = param[:key]
      if parameters[key]
        # Remove blank elements or those set to their defaults
        if parameters[key].blank? ||
          param[:null_equivalent].include?(parameters[key])
          parameters.delete(key)
        else
          value = parameters[key]
          case key
          # Slice off superfluous text
          when ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO,
            ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO
            parameters[key] = value.gsub(/[^\d]/, '')
          when BEDROOM_NUMBER, BATHROOM_NUMBER
            pair = room_number_scope_from_string(
              "#{key.to_s.chomp('_number').to_sym}", value )
            parameters.merge!( pair )
            parameters.delete( key ) # Remove non-Searchlogic param
          # Convert to array (actually, I think Searchlogic will still process
          # this correctly without converting to an array, but it makes it
          # more convenient when handling in other scripts
          when CATEGORIES_EQUALS_ANY, FEATURES_EQUALS_ALL, STYLES_EQUALS_ANY
            parameters[key] = value.split(' ')
          end
        end
      end
    end
    return parameters.merge( params[:q] || {} )
  end
  
  def required_search_param_keys
    keys = []
    SEARCH_PARAMS_MAP.map do |param|
      keys << param[:key] if param[:required]
    end
    keys.reject { |x| x.nil? }
  end
  
  def default_search_params
    if @active_agency.country
      country = @active_agency.country.cached_slug
    else
      country = search_params_defaults[ COUNTRY_EQUALS ]
    end
    {
      COUNTRY_EQUALS => country,
      CATEGORIES_EQUALS_ANY => search_params_defaults[ CATEGORIES_EQUALS_ANY ],
      LISTING_TYPE_EQUALS => search_params_defaults[ LISTING_TYPE_EQUALS ]
    }
  end
  
  def search_params_defaults
    result = {}
    SEARCH_PARAMS_MAP.each do |param|
      result["#{param[:key]}".to_sym] = param[:default]
    end
    return result
  end
  
  def listings_options( new_params = {} )
    
    parameters = new_params.dup
    
    # Make sure price range is sensible
    if parameters[ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO] ||
      parameters[ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO]
      lower = parameters[ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO].to_i
      upper = parameters[ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO].to_i
      if lower == 0 && upper == 0
        parameters.delete(ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO)
        parameters.delete(ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO)
      else
        if upper.zero? || lower >= upper
          parameters.delete(ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO)
        elsif lower.zero?
          parameters.delete(ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO)
        end
      end
    end
    
    # This translates Searchlogic params that should be represented by just one
    # parameter in the URL path
    INTERNAL_PARAM_KEYS.each do |key|
      parameters.delete( key ) if parameters[key].blank?
      next unless parameters[key]
      case key
      when BEDROOM_NUMBER_EQUALS
        parameters[BEDROOM_NUMBER] = "exactly-#{parameters[key]}-bedrooms"
      when BEDROOM_NUMBER_GTE
        parameters[BEDROOM_NUMBER] = "at-least-#{parameters[key]}-bedrooms"
      when BEDROOM_NUMBER_LTE
        parameters[BEDROOM_NUMBER] = "no-more-than-#{parameters[key]}-bedrooms"
      when BATHROOM_NUMBER_EQUALS
        parameters[BATHROOM_NUMBER] = "exactly-#{parameters[key]}-bathrooms"
      when BATHROOM_NUMBER_GTE
        parameters[BATHROOM_NUMBER] = "at-least-#{parameters[key]}-bathrooms"
      when BATHROOM_NUMBER_LTE
        parameters[BATHROOM_NUMBER] = "no-more-than-#{parameters[key]}" +
          "-bathrooms"
      end
      parameters.delete(key)
    end
    
    # Fix parameters in non-standard format
    parameters.each_pair do |key, value|
      # Convert parameters with arrays for values to strings
      parameters[key] = value.join(' ') if value.kind_of?(Array)
      # TODO: figure out if blank values are still present in the hash
      #(were appearing as ASK_AMOUNT... parameters)
      parameters.delete(key) if value.blank?
    end
    
    # Also trim path so that it is as short as possible
    keys_to_trim = []
    SEARCH_PARAMS_MAP.each_with_index do |map_param, i|
      key = map_param[:key]
      
      # All params should be present, then trimmed later
      parameters[key] = map_param[:null_equivalent][0] if parameters[key].nil?
      
      # Trim null equivalents (except for required parameters)
      if map_param[:null_equivalent].include?( parameters[key] )
        keys_to_trim << key
      else
        keys_to_trim = []
        # Some parameters have extra text to make them more readable and
        # search engine friendly
        case key
        when ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO
          parameters[key] = "over-#{new_params[key]}-dollars"
        when ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO
          parameters[key] = "under-#{new_params[key]}-dollars"
        end
      end
    end
    
    # Chop off all values set to their null equivalents
    keys_to_trim.each { |key| parameters.delete( key ) }
    
    # Set defaults for required parameters
    required_search_param_keys.each do |required_param|
      unless parameters[required_param]
        parameters[required_param] = default_search_params[required_param]
      end
    end
    
    # Append pagination parameters if necessary
    parameters.merge(
      pagination_params( new_params ).merge(
        :controller => :listings,
        :action => :index
      )
    )
  end
  
  def pagination_params( new_params = {} )
    pagination_keys = PAGINATE_PARAMS_MAP.map { |x| x[:key] }
    # If one of the pagination parameters is present, they must all be
    # added in order to match the corresponding route
    at_least_one_key = false
    pagination_keys.each do |key|
      if new_params.has_key?( key )
        at_least_one_key = true
        break
      end
    end
    return {} unless at_least_one_key
    
    # Get rid of non-pagination parameters
    parameters = new_params.dup
    parameters.each_key do |key|
      unless pagination_keys.include?( key )
        parameters.delete( key )
      end
    end
    
    # Make sure all pagination parameters are set
    PAGINATE_PARAMS_MAP.map do |map_param|
      unless parameters[map_param[:key]]
        parameters[map_param[:key]] = map_param[:null_equivalent][0]
      end
    end
    
    # Append the pagination parameters if present and at least one of them
    # is set to a value other than its null equivalent
    trim_keys = true
    PAGINATE_PARAMS_MAP.each do |map_param|
      unless map_param[:null_equivalent].include?(
        parameters[map_param[:key]] )
        trim_keys = false
      end
    end
    # Chop off all values set to their null equivalents
    if trim_keys
      PAGINATE_PARAMS_MAP.each do |map_param|
        parameters.delete( map_param[:key] )
      end
    end
    
    # Force pagination to have 'asc' or 'desc'
    unless parameters[:order].blank?
      unless parameters[:order].index(/asc|desc/)
        parameters[:order] += ' asc'
      end
    end
    
    return parameters
  end
  
  def room_comparator_and_number_from_string( type, value )
    # Chop off trailing label, i.e. " bedrooms"
    value.gsub!("-#{type.to_s.pluralize}", '')
    number = value.match(/\d/).to_s.to_i
    return nil if number.zero?
    return [ value.chomp(number.to_s).chomp('-'), number ]
  end
  
  def room_number_scope_from_string( type, value )
    result = room_comparator_and_number_from_string( type, value )
    return {} unless result
    comparator, number = result
    case comparator
    when 'at-least'
      scope = "property_#{type}_number_greater_than_or_equal_to".to_sym
    when 'no-more-than'
      scope = "property_#{type}_number_less_than_or_equal_to".to_sym
    else # when 'exactly'
      scope = "property_#{type}_number_equals".to_sym
    end
    return { scope => number }
  end
  
  def searchlogic_params_to_readable_params( parameters, type = 'url',
                                              insert_linebreaks = true )
    # Return values
    readable_string = ''
    non_readable_params = {}
        
    country = nil
    categories = categories_string = nil
    listing_type = nil
    barrio = nil
    canton = nil
    market = nil
    province = nil
    zone = nil
    bedroom_number, bedroom_comparator = nil
    bathroom_number, bathroom_comparator = nil
    ask_amount_maximum = nil
    ask_amount_minimum = nil
    styles = styles_string = nil
    features = features_string = nil
    parameters.each_pair do |key, value|
      case key.to_sym
      when COUNTRY_EQUALS
        country = value
        country = country.titleize if type == 'text'
      when CATEGORIES_EQUALS_ANY
        categories = value
        if categories.kind_of?(Array)
          categories_string = categories.to_sentence
        else
          categories_string = categories
        end
      when LISTING_TYPE_EQUALS
        listing_type = value
      when BARRIO_EQUALS
        barrio = value
        barrio = barrio.titleize if type == 'text'
      when CANTON_EQUALS
        canton = value
        canton = canton.titleize if type == 'text'
      when MARKET_EQUALS
        market = value
        market = market.titleize if type == 'text'
      when PROVINCE_EQUALS
        province = value
        province = province.titleize if type == 'text'
      when ZONE_EQUALS
        zone = value
        zone = zone.titleize if type == 'text'
      when BEDROOM_NUMBER_EQUALS
        bedroom_comparator = 'exactly'
        bedroom_number = value
      when BEDROOM_NUMBER_GTE
        bedroom_comparator = 'at least'
        bedroom_number = value
      when BEDROOM_NUMBER_LTE
        bedroom_comparator = 'no more than'
        bedroom_number = value
      when BATHROOM_NUMBER_EQUALS
        bathroom_comparator = 'exactly'
        bathroom_number = value
      when BATHROOM_NUMBER_GTE
        bathroom_comparator = 'at least'
        bathroom_number = value
      when BATHROOM_NUMBER_LTE
        bathroom_comparator = 'no more than'
        bathroom_number = value
      when ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO
        ask_amount_maximum = value.to_s
      when ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO
        ask_amount_minimum = value.to_s
      when STYLES_EQUALS_ANY
        styles = value
        if styles.kind_of?(Array)
          styles_string = styles.to_sentence
        else
          styles_string = styles
        end
      when FEATURES_EQUALS_ALL
        features = value
        if features.kind_of?(Array)
          features_string = features.to_sentence
        else
          features_string = features
        end
      else
        non_readable_params.merge!( key => value.to_s )
      end
    end
    if type == 'text' # (display info about search results)
      delimiter = ' '
      spacer = ' '
      money_delimiter = ','
      money_symbol = '$'
      money_label = ''
      if insert_linebreaks
        linebreak = '<br />'
      else
        linebreak = ' / '
      end
    else # type == 'url' (build readable url)
      delimiter = '--'
      spacer = '-'
      money_delimiter = ''
      money_symbol = ''
      money_label = spacer + 'dollars'
    end
    country = 'all' unless country
    categories_string = 'property' unless categories_string
    unless listing_type
      listing_type = 'for' + spacer + 'sale' + spacer + 'or' + spacer + 'rent'
    end
    readable_string = country + delimiter + categories_string + delimiter +
      listing_type
    unless country == 'all'
      place_separator = 'in'
      place_delimiter = delimiter
      if barrio
        readable_string += delimiter + 'in' + spacer + barrio
        place_separator = ','
        place_delimiter = ''
      end
      if canton
        readable_string += place_delimiter + place_separator + spacer + canton
        place_separator = ','
        place_delimiter = ''
      end
      if market
        readable_string += place_delimiter + place_separator + spacer + market
        place_separator = ','
        place_delimiter = ''
      end
      if province
        readable_string += place_delimiter + place_separator + spacer + province
        place_separator = ','
        place_delimiter = ''
      end
      if zone
        readable_string += place_delimiter + place_separator + spacer + zone
      end
    end
    if bedroom_number || bathroom_number
      readable_string += linebreak
      bed_and_bath = []
      if bedroom_number
        bed_and_bath << bedroom_comparator + spacer + bedroom_number.to_s +
          spacer + 'bedrooms'
      end
      if bathroom_number
        bed_and_bath << bathroom_comparator + spacer + bathroom_number.to_s +
          spacer + 'bathrooms'
      end
      readable_string += bed_and_bath.to_sentence.capitalize
    end
    if ask_amount_maximum
      readable_string += delimiter + 'under' + spacer +
        number_to_currency(ask_amount_maximum.to_i,
          :precision => 0,
          :unit => money_symbol,
          :delimiter => money_delimiter
        ) +
        money_label
    end
    if ask_amount_minimum
      readable_string += delimiter + 'over' + spacer +
        number_to_currency(ask_amount_minimum.to_i,
          :precision => 0,
          :unit => money_symbol,
          :delimiter => money_delimiter
        ) +
        money_label
    end
    if features_string
      if type == 'text'
        readable_string += delimiter + linebreak + 'Features: ' +
          features_string
      else
        readable_string += delimiter + features_string
      end
    end
    if styles_string
      if type == 'text'
        readable_string += delimiter + linebreak + 'Styles: ' + styles_string
      else
        readable_string += delimiter + styles_string
      end
    end
#    if features
#      if type == 'text'
#        prompt = linebreak + 'Features:'
#        feature_delimiter = ',' + delimiter
#      else
#        prompt = 'features'
#        feature_delimiter = delimiter
#      end
#      features.each_with_index do |feature, j|
#        if j.zero?
#          readable_string += delimiter + prompt + spacer + feature
#        else
#          readable_string += feature_delimiter + feature
#        end
#      end
#    end
    readable_string.gsub!('-', ' ') if type == 'text'
    return [ readable_string, non_readable_params ]
  end
end
