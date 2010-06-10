module Admin::BarriosHelper
  
  def set_barrio_form_list_data
    @lists = {}
    @lists[:countries] = Country.find(:all).map {
      |country| [country.name, country.id] }
    if @barrio.country_id
      @lists[:zones] = Zone.find(:all,
        :include => nil,
        :conditions => { :country_id => @barrio.country_id },
        :select => ['id, name']
      ).map {
        |zone| [zone.name, zone.id] }
      @lists[:provinces] = Province.find(:all,
        :include => nil,
        :conditions => { :country_id => @barrio.country_id },
        :select => ['id, name']
      ).map {
        |province| [province.name, province.id] }
      @lists[:markets] = Market.find(:all,
        :include => nil,
        :conditions => { :country_id => @barrio.country_id },
        :select => ['id, name']
      ).map {
        |market| [market.name, market.id] }
    else
      @lists[:zones] = [['Please select country', '']]
      @lists[:provinces] = [['Please select country', '']]
      @lists[:markets] = [['Please select country', '']]
    end
    return @lists
  end  
end

