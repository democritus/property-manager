class LegacyStyleAssignment < LegacyBase

  set_table_name 'real_estate_listing'
  set_primary_key nil
  
  belongs_to :legacy_style, :foreign_key => 'StyleID'
  belongs_to :legacy_listing, :foreign_key => 'PropertyID'
  belongs_to :legacy_property, :foreign_key => 'PropertyID'
  
  def map
    {
      :style_id => self.new_style_id,
#      :property_id => self.propertyid
    }
  end
  
  def new_style_id
    Style.find_by_name(equivalent_name(self.legacy_style.style)).id
  end
  
  
  private
  
  def equivalent_name( legacy_name )
    name = case legacy_name
    when 'Contemporary'
      'Modern'
    when 'Split-Level'
      'Split-level'
    else
      legacy_name
    end
  end
end
