class OldBarrioearthData < ActiveRecord::Migration

  def connect_to_old_barrioearth
    # lets manually connect to the proper db
    ActiveRecord::Base.establish_connection(
      :adapter => 'mysql',
      :host => 'localhost',
      :username => 'be_user_php',
      :password => 'jupit3r',
      :database => 'barrioearth_php'
    )
  end
  

  
  def old_properties
    connect_to_old_barrioearth
  end
  
  def old_image_root
    if RAILS_ENV = 'production'
      '/var/www/old.barrioearth.com/www/images/real_estate_listing/'
    else
      '/home/brian/Sites/old.barrioearth.com/www/images/real_estate_listing/'
    end
  end
  
  def mapped_style_name( input )
    if property[:style_name] == 'aframe'
      property[:style_name] = 'a-frame'
    end
  end
  
  def old_properties
    
  end
  
  def collection_from_list( file )
    open(file) do |data|
      i = 0
      data.read.each_line do |line|
        arr = line.chomp.split("|").map { |x| x.chomp }
        collection << {
          :old_property_id => arr[0],
          :category_name => arr[1],
        }
        i += 1
      end
    end
    return collection
  end
  
  def categories_from_list
    file = '/home/brian/tmp/categories.txt'
    open(file) do |data|
      i = 0
      data.read.each_line do |line|
        arr = line.chomp.split("|").map { |x| x.chomp }
        categories << {
          :old_property_id => arr[0],
          :category_name => arr[1],
        }
        i += 1
      end
    end
    return categories
  end
  
  def features_from_list
    file = '/home/brian/tmp/features.txt'
    open(file) do |data|
      i = 0
      data.read.each_line do |line|
        arr = line.chomp.split("|").map { |x| x.chomp }
        features << {
          :old_property_id => arr[0],
          :feature_name => arr[1],
        }
        i += 1
      end
    end
    return features
  end
  
  def images_from_list
    file = '/home/brian/tmp/images.txt'
    open(file) do |data|
      i = 0
      data.read.each_line do |line|
        arr = line.chomp.split("|").map { |x| x.chomp }
        images << {
          :old_property_id => arr[0],
          :image_name => arr[1],
          :image_type => arr[2],
          :caption => arr[3],
          :position => arr[4]
        }
        i += 1
      end
    end
    return images
  end
  
  def images_map
    {
      # Temporary (not mapped)
      :old_property_id => [ 0, 'PropertyId', 'real_estate_listing_images',
        true ],
      
      # Temporary (combined to derive new values)
      :image_name => [ 1, 'ImageName', 'real_estate_listing_images', true ],
      :image_type => [ 2, 'ImageType', 'real_estate_listing_images', true ],
      
      # One-to-one mapping
      :caption => [ 3, 'Caption', 'real_estate_listing_images', false ],
      :position => [ 4, 'OrderNum', 'real_estate_listing_images', false ]
    }
  end
  
  def property_map
    {
      # Temporary (not mapped)
      :old_property_id => [ 0, 'PropertyId', 'real_estate_listing', true ],
      
      # Nested model placeholder
      :listings => false,
      :images => false,
      :styles => false,
      :features => false,
      :categories => false,
      
      # One-to-one mapping
      :property_name => [ 1, 'PropertyName', 'real_estate_listing', false ],
      :bedroom_number => [ 2, 'BedroomNum', 'real_estate_listing', false ],
      :bathroom_number => [ 3, 'BathNum', 'real_estate_listing', false ],
      :land_size => [ 4, 'LandSize', 'real_estate_listing', false ],
      :construction_size => [ 5, 'ConstructionSize', 'real_estate_listing',
        false ],
      :stories => [ 6, 'Stories', 'real_estate_listing', false ],
      :parking_spaces => [ 7, 'ParkingSpaces', 'real_estate_listing', false ],
      :year_built => [ 8, 'YearBuilt', 'real_estate_listing', false ]
    }
  end
  
  def listing_map
    {
      # Temporary (not mapped)
      :old_property_id => [ 0, 'PropertyID', 'real_estate_listing', true ],
       
      # One-to-one mapping
      :ask_amount => [ 9, 'AskPrice', 'real_estate_listing', false ],
      :admin_notes => [ 14, 'AdminNotes', 'real_estate_listing', true ],
      
      # Temporary (used to look up value)
      :listing_type => [ 10, 'ListingType', 'real_estate_listing', true ],
      :currency_code => [ 10, 'CurrencyCode', 'real_estate_listing', true ],
      :style_name => [ 10, 'Style', 'property_style', true ],
              
      # Temporary (combined with other values)
      :headliner => [ 10, 'Headliner_en', 'real_estate_listing', true ],
      :summary => [ 11, 'Summary_en', 'real_estate_listing', true ],
      :listing_text => [ 12, 'ListingText_en', 'real_estate_listing', true ],
      :more_info => [ 13, 'MoreInfo_en', 'real_estate_listing', true ]
    }
  end
  
  def map_property( field_values )
    property = []
    old_property_id = field_values[property_map[:old_property_id][0]]
    property_map.each_pair do |key, value|
      case key
      when :listings
        property[key] = [ map_listing( old_property_id ) ]
      when :categories
        property[key] = [ categories_for_property( old_property_id ) ]
      when :features
        property[key] = [ features_for_property( old_property_id ) ]
      when :images
        property[key] = [ images_for_property( field_values ) ]
      when :styles
        property[key] = [ styles_for_property( old_property_id ) ]
      else
        property[key] = old_property_id
      end
    end
    return property
  end
  
  def map_listing( old_property_id )
    listing = {}
    listing_map.each_pair do |key, value|
      listing[key] = old_property_id
    end
    return listing
  end
  
  def categories_for_property( old_property_id )        
    categories = []
    categories_from_list.each do |category|
      if category[:old_property_id] == old_property_id
        categories << category
        
        # If list is in ascending order of old_property_id, then we can
        # stop checking for matches if current value is greater
        break if category[:old_property_id] > old_property_id
      end
    end
    return categories
  end
  
  def features_for_property( old_property_id )        
    features = []
    features_from_list.each do |feature|
      if feature[:old_property_id] == old_property_id
        features << feature
        
        # If list is in ascending order of old_property_id, then we can
        # stop checking for matches if current value is greater
        break if feature[:old_property_id] > old_property_id
      end
    end
    return features
  end
  
  def styles_for_property( old_property_id )        
    styles = []
    styles_from_list.each do |style|
      if style[:old_property_id] == old_property_id
        styles << style
        
        # If list is in ascending order of old_property_id, then we can
        # stop checking for matches if current value is greater
        break if style[:old_property_id] > old_property_id
      end
    end
    return styles
  end
  
  def images_for_property( field_values )
    images = []
    images_from_list.each do |image|
      if image[:old_property_id] == field_values[image_map[:old_property_id][0]]
        # Original image may be one of these:
        property_name = field_values[image_map[:name][0]]
        extension = field_values[image_map[:file_type][0]].downcase
        possible_filenames = [
          property_name + '_original.' + extension,
          property_name + '.' + extension
        ]
        path_to_images = old_image_root + image[:old_property_id].to_s +
          '/images/'
        0..1.each do |count|
          path = path_to_images + possible_filenames[count]
          file = File.new(path)
          if file.exists?
            image[:image_filename] = possible_filenames[count]
            image[:image_file] = old_image_root + image[:image_filename]
            break
          end
        end
        if image[:image_filename]
          image.delete(:image_name)
          image.delete(:image_type)
          properties[i][:images] << image
        end
        
        # If list is in ascending order of old_property_id, then we can
        # stop checking for matches if current value is greater
        break if image[:old_property_id] > arr[0]
      end
    end
  end
  
  def self.up
    double_break = '<br /><br />'
    properties = []
    file = '/home/brian/tmp/listings.txt'
    open(file) do |data|
      i = 0
      data.read.each_line do |line|
        field_values = line.chomp.split("|").map { |x| x.chomp }
        
        properties << map_property ( field_values )

        
        
        
        
        
        i += 1
      end
    end
    
    i = 0
    properties_from_list.each do |property|
      # TODO: make sure styles, categories, and features are automatically
      # cloned to associated listings (via Listing model after_save filter)
      property[:style_assignments] = []
      property[:style_name] = mapped_style_name( property[:style_name] )
      if property[:style_name]
        style = Style.find_by_name( property[:style_name] )
        if style
          property[:style_assignments] << {
            :style_id => style.id,
            :primary_style => true
          }
        end
      end
      property[:category_assignments] = []
      if property[:categories]
        property[:categories].each_with_index do |category, j|
          property[:categories][j][:category_name] = mapped_category_name(
            category[:category_name] )
          property[:categories][j][:category_assignments] = []
          category = Category.find_by_name( category[:category_name] )
          if category
            property[:categories][j][:category_assignments] << {
              :category_id => category.id
            }
          end
        end
      end
      property[:feature_assignments] = []
      if property[:features]
        property[:features].each_with_index do |feature, j|
          property[:features][j][:feature_name] = mapped_feature_name(
            feature[:feature_name] )
          property[:features][j][:feature_assignments] = []
          feature = Feature.find_by_name( features[:feature_name] )
          if feature
            property[:features][j][:feature_assignments] << {
              :feature_id => feature.id
            }
          end
        end
      end
      if property[:listings]
        property[:listings].each_with_index do |listing, j|
          if listing[:listing_type]
            case listing[:listing_type]
            when 'rent'
              listing[:listing_type] = 'for rent'
            when 'both'
              listing[:listing_type] = 'for sale'
              # Add listing to end of array, but as rental
              property[:listings] << listing.merge(
                :listing_type => 'for rent' )
            else # 'sale'
              listing[:listing_type] = 'for sale'
            end
            listing_type = ListingType.find_by_name( listing[:listing_type] )
            if listing_type
              property[:listings][j][:listing_type_id] = listing_type.id 
            end
          end
          if listing[:currency_code]
            currency = Currency.find_by_alphabetic_code(
              listing[:currency_code] )
            property[:listings][j][:currency_id] = currency.id if currency
          end
        end
        property[:listings].delete( :listing_type )
        property[:listings].delete( :currency_code )
        property[:listings].delete( :style_name )
      end
      property.delete( :categories )
      property.delete( :features )
      property.delete( :old_property_id )
      property.delete( :style_name )
      property.merge!( :position => i + 1 ) unless property[:position]
      
#      # TODO: make sure records for nested models are saved too
#      Property.create!( property )
      i += 1
    end
  end
  
  def self.down
  end
end
