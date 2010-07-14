class LegacyFeatureAssignment < LegacyBase

  set_table_name 'real_estate_listing_feature'
  set_primary_key nil
  
  belongs_to :legacy_feature, :foreign_key => 'FeatureID'
  belongs_to :legacy_listing, :foreign_key => 'PropertyID'
  belongs_to :legacy_property, :foreign_key => 'PropertyID'
  
  def map
    {
      :feature_id => new_feature_id,
      :feature_assignable_id => new_property_id,
      :feature_assignable_type => 'Property'
    }
  end
  
  def new_feature_id
    feature = Feature.find_by_name(
      equivalent_name(self.legacy_feature.FeatureName).downcase
    )
    feature ? feature.id : nil
  end
  
  
  private
  
  def equivalent_name( legacy_name )
    name = case legacy_name
    when 'Pool'
      'swimming pool'
    when 'Garden'
      'front garden'
    when 'Beach home'
      'ocean view'
    else
      legacy_name
    end
  end
end
