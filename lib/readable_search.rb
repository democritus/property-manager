module ReadableSearch
  
  def self.included(base)
    base.module_eval do
      include ActionView::Helpers::NumberHelper
    end
  end
  
  # Remove extraneous words that are not actually part of the lookup value
  def listings_params(parameters = nil)
    if parameters.nil?
      parameters = params.dup
    end
    
    SEARCHLOGIC_PARAMS_MAP.each do |param|
      if parameters[param[:key]]
        # Remove elements set to their defaults
        if parameters[param[:key]] == param[:default_value]
          parameters.delete(param[:key])
        else
          case param[:key]
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
    return parameters.merge( params[:q] || {} )
  end
  
  # Prepare params for use with Searchlogic plugin by removing non-Searchlogic
  # elements, i.e. :controller, :action, :page, :order, :order_dir, etc.
  def search_params(parameters = nil)
    if parameters.nil?
      parameters = params.dup
    end
    # Remove non-Searchlogic elements
    searchlogic_keys = SEARCHLOGIC_PARAMS_MAP.map { |param| param[:key] }
    parameters.delete_if {
      |key, value| ! searchlogic_keys.include?(key.to_sym) }
      
    # TODO: perhaps better to get friendly_id working with Searchlogic instead?
    # Replace dashes with spaces so that incoming values will match
    # database values
    parameters.each { |k, v| parameters[k] = v.to_s.gsub('-', ' ') }
    return listings_params(parameters)
  end
  
  # Make params more human readable and keyword-rich so that URLs are better
  # for search engines
  def verbose_params(parameters = nil)
    if parameters.nil?
      parameters = params.dup
    end
    LISTING_PARAMS_MAP.each do |param|
      string_key = param[:key].to_s
      value = parameters[string_key]
      if value
        unless value == param[:default_value]
          case param[:key]
            # Slice off "under " and " dollars"
            when :ask_amount_less_than_or_equal_to
              parameters[string_key] = 'under ' + value + ' dollars'
            # Slice off "over " and " dollars"
            when :ask_amount_greater_than_or_equal_to
              parameters[string_key] = 'over ' + value + ' dollars'
          end
        end
      else
        # All possible listings
        parameters.merge!(param[:key].to_s => param[:default_value])
      end
    end
    # TODO: perhaps better to get friendly_id working with Searchlogic instead?
    parameters.each { |k, v| parameters[k] = v.to_s.gsub(' ', '-') }
    
    return parameters
  end
  
  def searchlogic_params_to_readable_params(parameters, type = 'url',
                                              insert_linebreaks = true)
    # Return values
    readable_string = ''
    non_readable_params = {}
        
    country = nil
    category = nil
    listing_type = nil
    barrio = nil
    market = nil
    ask_amount_maximum = nil
    ask_amount_minimum = nil
    style = nil
    features = nil
    parameters.each_pair do |key, value|
      case key.to_sym
        when :property_barrio_country_name_equals
          country = value
        when :categories_name_equals
          category = value
        when :listing_type_name_equals
          listing_type = value
        when :property_barrio_name_equals
          barrio = value
        when :property_barrio_market_name_equals
          market = value
        when :ask_amount_less_than_or_equal_to
          ask_amount_maximum = value.to_s
        when :ask_amount_greater_than_or_equal_to
          ask_amount_minimum = value.to_s
        when :styles_name_equals
          style = value
        when :features_name_equals_any
          features = value
        else
          non_readable_params.merge!(key => value.to_s)
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
    category = 'property' unless category
    unless listing_type
      listing_type = 'for' + spacer + 'sale' + spacer + 'or' + spacer + 'rent'
    end
    readable_string = country + delimiter + category + delimiter + listing_type
    unless country == 'all'
      if market
        if barrio
          readable_string += delimiter + 'in' + spacer + barrio + delimiter +
            'de' + spacer + market
        else
          readable_string += delimiter + 'in' + spacer + market
        end
      end
    end
    if ask_amount_maximum
      readable_string += delimiter + 'under' + spacer +
        number_to_currency(ask_amount_maximum,
          :precision => 0,
          :unit => money_symbol,
          :delimiter => money_delimiter
        ) +
        money_label
    end
    if ask_amount_minimum
      readable_string += delimiter + 'over' + spacer +
        number_to_currency(ask_amount_minimum,
          :precision => 0,
          :unit => money_symbol,
          :delimiter => money_delimiter
        ) +
        money_label
    end
    if style
      if type == 'text'
        readable_string += ',' + delimiter + style + spacer + 'style'
      else
        readable_string += delimiter + style + spacer + 'style'
      end
    end
    if features
      if type == 'text'
        prompt = linebreak + 'Features:'
        feature_delimiter = ',' + delimiter
      else
        prompt = 'features'
        feature_delimiter = delimiter
      end
      features.each_with_index do |feature, j|
        if j.zero?
          readable_string += delimiter + prompt + spacer + feature
        else
          readable_string += feature_delimiter + feature
        end
      end
    end
    return [readable_string, non_readable_params]
  end
end
