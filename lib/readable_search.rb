module ReadableSearch
  
  def self.included(base)
    base.module_eval do
      include ActionView::Helpers::NumberHelper
    end
  end
  
  #
  # Translate readable URL into parameters that Searchlogic understands
  #
  # EXAMPLE:
  #
  # URL
  # http://heredia.barrioearth-dev.com:3000/real_estate/
  # ?listing=Costa+Rica--Homes--for+sale--in--Santo+Domingo--de-Heredia--
  # under-500000-dollars--over-200000-dollars--A-frame-style
  #
  # Searchlogic parameters
  # search[property_barrio_country_name_equals]=Costa+Rica
  # search[categories_name_equals]=Homes
  # search[listing_type_name_is]=for+sale
  # search[property_barrio_name_equals]=Santo+Domingo
  # search[property_barrio_market_name_equals]=Heredia
  # search[ask_amount_greater_than_or_equal_to]=200000
  # search[ask_amount_less_than_or_equal_to]=500000
  # search[styles_name_equals]=A-Frame
  #
  def readable_string_to_searchlogic_params(readable_string)    
    
    # "+" char is not replaced with space if string comes from request uri
    # instead of querystring
    readable_string.gsub!(/\+/, ' ')
    
    return {} unless readable_string
    values = readable_string.split('--')
    search_params = {}
    location = []
    features = nil
    values.each_with_index do |value, i|
      case i
        when 0 # Country
          unless value == 'all'
            search_params = {:property_barrio_country_name_equals => value}
          end
        when 1 # Category
          unless value == 'property'
            search_params.merge!(:categories_name_equals => value)
          end
        when 2 # Listing type (for sale or for rent)
          if value == 'for sale' || value == 'for rent'
            search_params.merge!(:listing_type_name_equals => value)
          end
        else # Location, Price Range, Style or Features
          prefix = value.slice(0..2)
          if prefix == 'in-' || prefix == 'de-'
            location << value.slice(3..-1)
              # barrio shouldn't be specified unless market is
              # specified as well
          elsif value.slice(0..5) == 'under-'              
            search_params.merge!(:ask_amount_less_than_or_equal_to =>
              value.slice(6..-1).slice(0..-9).to_i)
          elsif value.slice(0..4) == 'over-'
            search_params.merge!(:ask_amount_greater_than_or_equal_to =>
              value.slice(5..-1).slice(0..-9).to_i)
          elsif value.slice(-6..-1) == '-style'
            search_params.merge!(:styles_name_equals => value.slice(0..-7))
          elsif value.slice(0..8) == 'features-'
            features = [value.slice(9..-1)]
          else
            features << value if features
          end
      end
    end
    unless location.empty?
      if location.length > 1
        search_params.merge!(:property_barrio_name_equals => location[0])
        search_params.merge!(:property_barrio_market_name_equals => location[1])
      else
        search_params.merge!(:property_barrio_market_name_equals => location[0])
      end
    end
    search_params.merge!(:features_name_equals_any => features) if features
    
    return search_params || {}
  end
  
  #
  # Translate Searchlogic parameters to readable URL
  #
  # EXAMPLE:
  #
  # Searchlogic parameters
  # search[property_barrio_country_name_equals]=Costa+Rica
  # search[categories_name_equals]=Homes
  # search[listing_type_name_equals]=for+sale
  # search[property_barrio_name_equals]=Santo+Domingo
  # search[property_barrio_market_name_equals]=Heredia
  # search[ask_amount_greater_than_or_equal_to]=200000
  # search[ask_amount_less_than_or_equal_to]=500000
  # search[styles_name_equals]=A-Frame
  #
  # URL
  # http://heredia.barrioearth-dev.com:3000/real_estate/
  # ?listing=Costa+Rica--Homes--for+sale--in--Santo+Domingo--de-Heredia--
  # under-500000-dollars--over-200000-dollars--A-frame-style
  #
   
  def readable_listings_path(search_params, params_to_persist = {},
        exclude_keys = [], readable_key = :search, searchlogic_key = :q)
    new_search_params = search_params.dup
    unless exclude_keys.empty?
      new_search_params.delete_if { |key, value| exclude_keys.include?(key) }
    end
    readable_string, non_readable_params = searchlogic_params_to_readable_params(
      new_search_params)
    new_params = {}
    unless readable_string.empty?
      new_params.merge!(readable_key => readable_string)
    end
    new_params.merge!(searchlogic_key => non_readable_params)
    unless params_to_persist.empty?
      new_params = params_to_persist.merge(new_params)
    end
    new_params.delete(searchlogic_key) if new_params[searchlogic_key].empty?
    
    # If caching is turned on, use caching-friendly URLs.
    # Example:
    # /real_estate?search=Costa+Rica--property--for+sale&page=1&order=publish_date&order_dir=desc
    # ...becomes...
    # /real_estate/search/Costa+Rica--property--for+sale/1/publish_date/desc
    
    # TODO: more granulated caching will allow for more efficiency since cached
    # subsets can be cleared instead of all listings for a given agency
    if @page_caching_active
      options = { :controller => :listings, :action => :index }
      [
        :property_barrio_country_name_equals,
        :categories_name_equals,
        :listing_type_name_equals,
        :property_barrio_market_name_equals,
        :property_barrio_name_equals,
        :ask_amount_less_than_or_equal_to,
        :ask_amount_greater_than_or_equal_to,
        :styles_name_equals,
        :features_name_equals_any,
        :page,
        :order,
        :order_dir,
        :q
      ].each do |key|      
        options.merge!(key => new_params[key]) if new_params[key]
      end
      return url_for(options)
    else
      return listings_path(new_params)
    end
  end
  
  def searchlogic_params_to_readable_params(searchlogic_params, type = 'url',
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
    searchlogic_params.each_pair do |key, value|
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
