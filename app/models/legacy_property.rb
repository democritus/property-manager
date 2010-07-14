class LegacyProperty < LegacyBase

  set_table_name 'real_estate_listing'
  set_primary_key 'PropertyID'
  
  # Join to self so that it is as if each property has an associated "listing"
  has_many :legacy_listings, :foreign_key => 'PropertyID'
  has_many :legacy_property_images, :foreign_key => 'PropertyID'
  
  has_many :legacy_categories, :through => :legacy_category_assignments
  has_many :legacy_styles, :through => :legacy_style_assignments
  has_many :legacy_features, :through => :legacy_feature_assignments
  
  has_many :legacy_category_assignments, :foreign_key => 'PropertyID'
  has_many :legacy_style_assignments, :foreign_key => 'PropertyID'
  has_many :legacy_feature_assignments, :foreign_key => 'PropertyID'
    
  def map
    {
      :name => self.PropertyName,
      :bedroom_number => self.BedroomNum,
      :bathroom_number => self.BathNum,
      :land_size => self.LandSize,
      :construction_size => self.ConstructionSize,
      :stories => self.Stories,
      :parking_spaces => self.ParkingSpaces,
      :year_built => self.YearBuilt,  
      :agency_id => forced_agency_id,
      :legacy_id => self.PropertyID

# REMOVED - couldn't figure out how to do this nested, so doing each model
# separately and saving legacy id in "legacy_id" so that associations can
# be figured out (since new id is different than the legacy id)
#      :legacy_listings_attributes => self.legacy_listings
#      :legacy_property_images => self.legacy_property_images,
#      :legacy_category_assignments => self.legacy_category_assignments,
#      :legacy_feature_assignments => self.legacy_feature_assignments,
#      :legacy_style_assignments => self.legacy_style_assignments
    }
  end
  
  
  private
  
  def forced_agency_id
    Agency.find(:first,
      :order => '(domain = "barrioearth.com" AND subdomain IS NULL) DESC'
    ).id
  end
end
