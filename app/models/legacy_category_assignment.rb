class LegacyCategoryAssignment < LegacyBase

  set_table_name 'real_estate_listing_category'
  set_primary_key nil
  
  belongs_to :legacy_category, :foreign_key => 'CategoryID'
  belongs_to :legacy_listing, :foreign_key => 'PropertyID'
  belongs_to :legacy_property, :foreign_key => 'PropertyID'
  
  def map
    {
      :primary_category => self.main,
      :category_id => self.new_category_id,
#      :property_id => self.propertyid
    }
  end
  
  def new_category_id
    Category.find_by_name(equivalent_name(self.legacy_category.categoryname)).id
  end
  
  
  private
  
  def equivalent_name( legacy_name )
    name = case legacy_name
    when 'Farms'
      'Farms & Ranches'
    when 'Estates & Villas'
      'Fine Homes & Estates'
    when 'Lots'
      'Residential Lots'
    when 'Resorts'
      'Commercial Development'
    else
      legacy_name
    end
  end
end
