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
