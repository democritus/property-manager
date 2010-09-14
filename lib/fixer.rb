def add_missing_category_assignments
  [
    { :name => 'Condominiums', :user_defined => false, :type => :both,
      :sale_highlighted => true, :rent_highlighted => false },
    { :name => 'Commercial', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'Apartments', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => true },
    { :name => 'Beachfront', :user_defined => false, :type => :sale,
      :sale_highlighted => true, :rent_highlighted => false },
    { :name => 'Oceanview', :user_defined => false, :type => :sale,
      :sale_highlighted => true, :rent_highlighted => false },
    { :name => 'Fine Homes & Estates', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    
    { :name => 'Vacation Rentals', :user_defined => false, :type => :rent,
      :sale_highlighted => false, :rent_highlighted => true },
    
    { :name => 'Homes', :user_defined => false, :type => :sale,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'Residential Lots', :user_defined => false, :type => :sale,
      :sale_highlighted => true, :rent_highlighted => false },
    { :name => 'Land', :user_defined => false, :type => :sale,
      :sale_highlighted => true, :rent_highlighted => false },
    { :name => 'Business Opportunities', :user_defined => false, :type => :sale,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'Hotels', :user_defined => false, :type => :sale,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'Bed & Breakfasts', :user_defined => false, :type => :sale,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'Restaurants & Bars', :user_defined => false, :type => :sale,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'Pre-construction', :user_defined => false, :type => :sale,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'Farms & Ranches', :user_defined => false, :type => :sale,
      :sale_highlighted => true, :rent_highlighted => false },
    { :name => 'Residential Development', :user_defined => false,
      :type => :sale, :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'Commercial Development', :user_defined => false, :type => :sale,
      :sale_highlighted => false, :rent_highlighted => false }
  ].each do |record|
    types = []
    case record[:type]
    when :sale, :both
      types << 'for sale'
    when :rent, :both
      types << 'for rent'
    end
    record.delete(:type)
    record.delete(:rent_highlighted)
#    if category = Category.create!(record)
    category = Category.find_by_name( record[:name] )
    if category
      types.each do |type|
        listing_type = ListingType.find_by_name(type)
        if listing_type
          attributes = {
            :category_assignable_type => 'ListingType',
            :category_assignable_id => listing_type.id,
            :category_id => category.id
          }
          case listing_type
          when :sale
            if record[:sale_highlighted]
              attributes.merge!( :highlighted => true )
              record.delete(:sale_highlighted)
            end
          when :rent
            if record[:rent_highlighted]
              attributes.merge!( :highlighted => true )
              record.delete(:rent_highlighted)
            end
          end
          category_assignment = CategoryAssignment.find( :first,
            :conditions => 'category_assignable_type = "ListingType"' +
              " AND category_assignable_id = #{listing_type.id}" +
              " AND category_id = #{category.id}"
          )
          CategoryAssignment.create!( attributes ) unless category_assignment
        end
      end
    end
  end
end

def add_missing_feature_assignments
  [
    { :name => 'swimming pool', :user_defined => false, :type => :both,
      :sale_highlighted => true, :rent_highlighted => false },
    { :name => 'hot water', :user_defined => false, :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'hardwood floors', :user_defined => false, :type => :both,
      :sale_highlighted => true, :rent_highlighted => false },
    { :name => 'central air', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'central heat', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'spa/hot tub', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'carport', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'RV/boat parking', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'tennis court', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'disability features', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'den/office', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'energy efficient home', :user_defined => false, :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'fireplace', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'burglar alarm', :user_defined => false, :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'laundry room', :user_defined => false, :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'insulated glass', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'front garden', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'back garden', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'front yard', :user_defined => false, :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'backyard', :user_defined => false, :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'basement', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'close to or on a paved road', :user_defined => false,
      :type => :both, :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'privacy', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'natural area', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'close to surf break', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'close to school', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'close to hospital', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'close to services', :user_defined => false, :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'close to airport', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'gated community', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'non-gated community', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => '24-hour security', :user_defined => false, :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'air conditioning', :user_defined => false, :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'ocean view', :user_defined => false, :type => :both,
      :sale_highlighted => true, :rent_highlighted => false },
    { :name => 'mountain view', :user_defined => false, :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'washer/dryer', :user_defined => false, :type => :both,
      :sale_highlighted => true, :rent_highlighted => true }
    
  ].each do |record|
    types = []
    case record[:type]
    when :sale, :both
      types << 'for sale'
    when :rent, :both
      types << 'for rent'
    end
    record.delete(:type)
#    if feature = Feature.create!(record)
    feature = Feature.find_by_name( record[:name] )
    if feature
      types.each do |type|
        listing_type = ListingType.find_by_name(type)
        if listing_type
          attributes = {
            :feature_assignable_type => 'ListingType',
            :feature_assignable_id => listing_type.id,
            :feature_id => feature.id
          }
          case listing_type
          when :sale
            if record[:sale_highlighted]
              attributes.merge!( :highlighted => true )
              record.delete(:sale_highlighted)
            end
          when :rent
            if record[:rent_highlighted]
              attributes.merge!( :highlighted => true )
              record.delete(:rent_highlighted)
            end
          end
          feature_assignment = FeatureAssignment.find( :first,
            :conditions => 'feature_assignable_type = "ListingType"' +
              " AND feature_assignable_id = #{listing_type.id}" +
              " AND feature_id = #{feature.id}"
          )
          FeatureAssignment.create!( attributes ) unless feature_assignment
        end
      end
    end
  end
end

def add_missing_style_assignments
  [
    { :name => 'A-Frame', :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'Bungalow', :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'Chalet', :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'Colonial', :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'Cottage', :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'Duplex', :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'Farmhouse', :type => :both,
      :sale_highlighted => true, :rent_highlighted => false },
    { :name => 'Georgian', :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'Log Cabin', :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'Mobile', :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'Modern', :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'Queen Anne', :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'Quinta', :type => :both,
      :sale_highlighted => true, :rent_highlighted => false },
    { :name => 'Ranch', :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'Split-level', :type => :both,
      :sale_highlighted => false, :rent_highlighted => false },
    { :name => 'Studio', :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'Townhouse', :type => :both,
      :sale_highlighted => true, :rent_highlighted => true },
    { :name => 'Victorian', :type => :both,
      :sale_highlighted => true, :rent_highlighted => true }
  ].each do |record|
    types = []
    case record[:type]
    when :sale, :both
      types << 'for sale'
    when :rent, :both
      types << 'for rent'
    end
    record.delete(:type)
#    if style = Style.create!(record)
    style = Style.find_by_name( record[:name] )
    if style
      types.each do |type|
        listing_type = ListingType.find_by_name(type)
        if listing_type
          attributes = {
            :style_assignable_type => 'ListingType',
            :style_assignable_id => listing_type.id,
            :style_id => style.id
          }
          case listing_type
          when :sale
            if record[:sale_highlighted]
              attributes.merge!( :highlighted => true )
              record.delete(:sale_highlighted)
            end
          when :rent
            if record[:rent_highlighted]
              attributes.merge!( :highlighted => true )
              record.delete(:rent_highlighted)
            end
          end
          style_assignment = StyleAssignment.find( :first,
            :conditions => 'style_assignable_type = "ListingType"' +
              " AND style_assignable_id = #{listing_type.id}" +
              " AND style_id = #{style.id}"
          )
          StyleAssignment.create!( attributes ) unless style_assignment
        end
      end
    end
  end
end

def fix_categories_listing_types
  # Delete all categories - listing types associations
  category_assignments = CategoryAssignment.find(:all,
    :conditions => 'category_assignable_type = "ListingType"'
  )
  CategoryAssignment.destroy( category_assignments.map { |record| record.id } )
  
  categories = Category.all
  categories.each do |category|
    case category.name
    when 'Condominiums', 'Commercial', 'Apartments'
      type = :both
    when 'Vacation Rentals'
      type = :rent
    else
      type = :sale
    end
    types = []
    case type
    when :sale, :both
      types << 'for sale'
    when :rent, :both
      types << 'for rent'
    end
    types.each do |type|
      listing_type = ListingType.find_by_name(type)
      if listing_type
        CategoryAssignment.create!(
          :category_assignable_type => 'ListingType',
          :category_assignable_id => listing_type.id,
          :category_id => category.id
        )
      end
    end
  end
end

def fix_features_listing_types
  # Delete all features - listing types associations
  feature_assignments = FeatureAssignment.find(:all,
    :conditions => 'feature_assignable_type = "ListingType"'
  )
  FeatureAssignment.destroy( feature_assignments.map { |record| record.id } )
  
  features = Feature.all
  features.each do |feature|
    case feature.name
    when 'washer/dryer'
      type = :rent
    else
      type = :both
    end
    types = []
    case type
    when :sale, :both
      types << 'for sale'
    when :rent, :both
      types << 'for rent'
    end
    types.each do |type|
      listing_type = ListingType.find_by_name(type)
      if listing_type
        FeatureAssignment.create!(
          :feature_assignable_type => 'ListingType',
          :feature_assignable_id => listing_type.id,
          :feature_id => feature.id
        )
      end
    end
  end
end

def fix_styles_listing_types
  # Delete all styles - listing types associations
  style_assignments = StyleAssignment.find(:all,
    :conditions => 'style_assignable_type = "ListingType"'
  )
  StyleAssignment.destroy( style_assignments.map { |record| record.id } )
  
  styles = Feature.all
  styles.each do |style|
    type = :both
    types = []
    case type
    when :sale, :both
      types << 'for sale'
    when :rent, :both
      types << 'for rent'
    end
    types.each do |type|
      listing_type = ListingType.find_by_name(type)
      if listing_type
        StyleAssignment.create!(
          :style_assignable_type => 'ListingType',
          :style_assignable_id => listing_type.id,
          :style_id => style.id
        )
      end
    end
  end
end

def clone_property_assignments
  listings = Listing.all
  listings.each do |listing|
    listing.clone_from_property
  end
end
