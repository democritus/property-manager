module ReadableSearch
  
  def self.included(base)
    base.module_eval do
      include ActionView::Helpers::NumberHelper
    end
  end
  
  # Remove extraneous words that are not actually part of the lookup value
  def listings_params( parameters = nil )
    if parameters.nil?
      parameters = params.dup
    end
    SEARCHLOGIC_PARAMS_MAP.each do |param|
      if parameters[param[:key]]
        # Remove elements set to their defaults
        if parameters[param[:key]] == param[:default_value]
          parameters.delete(param[:key])
        else
          value = parameters[param[:key]]
          case param[:key]
          # Slice off "under " and " dollars"
          when ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO
            parameters[param[:key]] = value.slice(6..-1).slice(0..-9)
          # Slice off "over " and " dollars"
          when ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO
            parameters[param[:key]] = value.slice(5..-1).slice(0..-9)
          end
        end
      end
    end
    return parameters.merge( params[:q] || {} )
  end
  
  # Prepare params for use with Searchlogic plugin by removing non-Searchlogic
  # elements, i.e. :controller, :action, :page, :order, :order_dir, etc.
  def search_params( parameters = nil )
    if parameters.nil?
      parameters = params.dup
    end
    # Remove non-Searchlogic elements
    searchlogic_keys = SEARCHLOGIC_PARAMS_MAP.map { |param| param[:key] }
    parameters.delete_if {
      |key, value| ! searchlogic_keys.include?( key.to_sym ) }
    return listings_params( parameters )
  end
  
  # Make params more human readable and keyword-rich so that URLs are better
  # for search engines
  def verbose_params( parameters = nil )
    if parameters.nil?
      parameters = params.dup
    end
    LISTING_PARAMS_MAP.each do |param|
      value = parameters[param[:key]]
      if value
        unless value == param[:default_value]
          case param[:key]
            # Slice off "under " and " dollars"
            when ASK_AMOUNT_LESS_THAN_OR_EQUAL_TO
              parameters[param[:key]] = 'under ' + value.to_s + ' dollars'
            # Slice off "over " and " dollars"
            when ASK_AMOUNT_GREATER_THAN_OR_EQUAL_TO
              parameters[param[:key]] = 'over ' + value.to_s + ' dollars'
          end
        end
      else
        # All possible listings
        parameters.merge!( param[:key] => param[:default_value] )
      end
    end
    return parameters
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
      when FEATURES_EQUALS_ANY
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
