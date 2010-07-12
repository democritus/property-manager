class LegacyListing < LegacyBase

  set_table_name 'real_estate_listing'
  set_primary_key 'PropertyID'
  
  # Join to self so that it is as if each listing belongs to a "property"
  belongs_to :legacy_properties, :foreign_key => 'PropertyID'
    
  def map
    {
#      :property_id => self.propertyid,
      :name => self.propertyname,
      :ask_amount => self.bedroomnum,
      :admin_notes => self.adminnotes,
      
      :description => self.headliner_en +
        '<br /><br />' + self.summary_en +
        '<br /><br />' + self.listingtext_en +
        '<br /><br />' + self.moreinfo_en,
      
      :listing_type_id => new_listing_type_id,
      :currency_id => new_currency_id
    }
  end
  
  
  private
  
  def equivalent_listing_type_name
    case self.listingtype
    when 'rent'
      'for rent'
    else
      'for sale'
    end
  end
  
  def new_listing_type_id
    return nil unless self.listingtype
    ListingType.find_by_name(equivalent_listing_type_name).id
  end
  
  def new_currency_id
    return nil unless self.currencycode
    Currency.find_by_name(self.currencycode).id
  end
end
