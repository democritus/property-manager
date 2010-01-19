module AgenciesHelper
    
  def broker(agency = nil)
    agency = @agency if agency.nil?
    if agency.broker
      (agency.broker.user.first_name + ' ' + agency.broker.user.last_name).strip
    else
      'Not yet assigned'
    end
  end
end
