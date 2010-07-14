class LegacyFeature < LegacyBase

  set_table_name 'property_feature'
  set_primary_key 'ID'
  
  has_many :legacy_feature_assignments, :foreign_key => 'FeatureID'
  
  has_many :legacy_properties, :through => :legacy_feature_assignments
end
