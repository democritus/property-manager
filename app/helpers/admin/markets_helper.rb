module Admin::MarketsHelper
  
  def setup_market_select_fields
    set_market_form_list_data
  end
  
  def set_market_form_list_data
    @lists = {}
    @lists[:agencies] = Agency.find(:all,
      :include => nil,
      :select => 'id, name'
    ).map {
      |agency| [agency.name, agency.id] }
    @lists[:countries] = Country.find(:all,
      :include => nil,
      :select => 'id, name'
    ).map {
      |country| [country.name, country.id] }
  end
  
  def primary_agency(market = nil)
    market = @market if market.nil?
    if market.agencies[0]
      market.agencies[0].name
    else
      'Not yet assigned'
    end
  end
end
