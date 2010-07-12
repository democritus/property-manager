class LegacyCategory < LegacyBase

  set_table_name 'real_estate_category'
  set_primary_key 'CategoryID'
  
  has_many :legacy_category_assignments, :foreign_key => 'CategoryID'
end
