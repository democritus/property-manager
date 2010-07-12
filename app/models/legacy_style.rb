class LegacyStyle < LegacyBase

  set_table_name 'property_style'
  set_primary_key 'ID'
  
  has_many :legacy_style_assignments, :foreign_key => 'StyleID'
end
