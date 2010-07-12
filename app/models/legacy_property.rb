class LegacyProperty < LegacyBase

  set_table_name 'real_estate_listing'
  set_primary_key 'PropertyID'

  # Join to self so that it is as if each property has an associated "listing"
  has_many :legacy_listings, :foreign_key => 'PropertyID'
  has_many :legacy_images, :foreign_key => 'PropertyID'
        
  def map
    {
      :name => self.propertyname,
      :bedroom_number => self.bedroomnum,
      :bathroom_number => self.bathnum,
      :land_size => self.landsize,
      :construction_size => self.constructionsize,
      :stories => self.stories,
      :parking_spaces => self.parkingspaces,
      :year_build => self.yearbuilt,
      
      :listings => self.legacy_listings,
      :images => self.legacy_images,
      :category_assignments => self.legacy_category_assignments,
      :feature_assignments => self.legacy_feature_assignments,
      :style_assignments => self.legacy_style_assignments
    }
  end
end
