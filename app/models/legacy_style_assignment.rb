class LegacyStyleAssignment < LegacyBase

  set_table_name 'real_estate_listing'
  set_primary_key nil
  
  belongs_to :legacy_style, :foreign_key => 'StyleID'
  belongs_to :legacy_listing, :foreign_key => 'PropertyID'
  belongs_to :legacy_property, :foreign_key => 'PropertyID'
  
  def map
    {
      :style_id => new_style_id,
      :style_assignable_id => new_property_id,
      :style_assignable_type => 'Property'
    }
  end
  
  def new_style_id
    style = Style.find_by_name(
      equivalent_name(self.legacy_style.Style)
    )
    style ? style.id : nil
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
