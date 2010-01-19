module Admin::AgenciesHelper
  
  include AgenciesHelper
  
  def setup_agency_select_fields
    set_agency_form_list_data
  end
  
  def set_agency_form_list_data
    @lists = {}
    @lists[:countries] = Country.find(:all,
      :include => nil,
      :select => 'id, name'
    ).map {
      |country| [country.name, country.id] }
    @lists[:markets] = []
    @lists[:partner_agencies] = []
    if @agency.country_id
      @lists[:markets] = Market.find(:all,
        :include => nil,
        :conditions => { :country_id => @agency.country_id },
        :select => ['id, name']
      ).map {
        |market| [market.name, market.id] }
      @lists[:partner_agencies] = Agency.find(:all,
        :include => nil,
        :conditions => { :country_id => @agency.country_id },
        :select => ['id, name']
      ).map {
        |agency| [agency.name, agency.id] }
    end
  end
  
  def primary_market(agency = nil)
    agency = @agency if agency.nil?
    if agency.markets[0]
      agency.markets[0].name
    else
      'Not yet assigned'
    end
  end
end
