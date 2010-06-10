module Admin::CantonsHelper
  
  def set_canton_form_list_data
    @lists = {}
    @lists[:countries] = Country.find(:all).map {
      |country| [country.name, country.id] }
    if @canton.country_id
      @lists[:provinces] = Province.find(:all,
        :include => nil,
        :conditions => { :country_id => @barrio.country_id },
        :select => ['id, name']
      ).map {
        |province| [province.name, province.id] }
    else
      @lists[:provinces] = [['Please select country', '']]
    end
    return @lists
  end  
end

