module Admin::ZonesHelper

  def set_zone_form_list_data
    @lists = {}
    @lists[:countries] = Country.find(:all,
      :include => nil,
      :select => 'id, name'
    ).map {
      |country| [country.name, country.id] }
    return @lists
  end  
end

