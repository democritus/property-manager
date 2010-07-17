class LegacyListing < LegacyBase

  set_table_name 'real_estate_listing'
  set_primary_key 'PropertyID'
  
  # Join to self so that it is as if each listing belongs to a "property"
  belongs_to :legacy_properties, :foreign_key => 'PropertyID'
  has_many :legacy_property_images, :foreign_key => 'PropertyID'
    
  def map
    {
      :property_id => new_property_id,
      :name => self.PropertyName,
      :label => 'legacy record',
      :ask_amount => self.AskPrice,
      :admin_notes => self.AdminNotes,
      :approved => new_approved,
      :legacy_reference_id => self.ReferenceID,
      
      :description => new_description,
      
      :listing_type_id => new_listing_type_id,
      :ask_currency_id => new_currency_id
    }
  end
  
  
  private
  
  def new_approved
    self.Hidden ? false : true
  end
  
  def new_description
    description = []
    description << self.Headliner_en if self.Headliner_en
    description << self.Summary_en if self.Summary_en
    description << self.ListingText_en if self.ListingText_en
    description << self.MoreInfo_en if self.MoreInfo_en
    return description.join('<br /><br />')
  end
  
  def equivalent_listing_type_name
    case self.ListingType
    when 'rent'
      'for rent'
    else
      'for sale'
    end
  end
  
  def new_listing_type_id
    return nil unless self.ListingType
    listing_type = ListingType.find_by_name(equivalent_listing_type_name)
    listing_type ? listing_type.id : nil
  end
  
  def new_currency_id
    return nil unless self.CurrencyCode
    currency = Currency.find_by_name(self.CurrencyCode)
    currency ? currency.id : nil
  end
end
