class LegacyFeatureAssignment < LegacyBase

  set_table_name 'real_estate_listing_feature'
  set_primary_key nil
  
  belongs_to :legacy_feature, :foreign_key => 'FeatureID'
  belongs_to :legacy_listing, :foreign_key => 'PropertyID'
  belongs_to :legacy_property, :foreign_key => 'PropertyID'
  
  def map
    {
      :feature_id => self.new_feature_id,
#      :property_id => self.propertyid
    }
  end
  
  def new_feature_id
    Feature.find_by_name(
      equivalent_name(self.legacy_feature.featurename.downcase)
    ).id
  end
  
  
  private
  
  def equivalent_name( legacy_name )
    name = case legacy_name
    when 'pool'
      'swimming pool'
    else
      legacy_name
    end
  end
end
