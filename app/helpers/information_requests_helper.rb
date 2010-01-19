module InformationRequestsHelper
  
  def type_of_request
    if @information_request.listing
      'property inquiry'
    else
      'general inquiry'
    end
  end
  
  def from_name
    unless @information_request['name'].blank? &&
    @information_request['email'].blank?
      unless @information_request['name'].blank?
        @information_request['name']
      else
        @information_request['email']
      end
    else
      'anonymous'
    end
  end
  
  def associated_agency(information_request = nil)
    if information_request.agency
      information_request.agency
    else
      if information_request.listing.property.agency
        information_request.listing.property.agency
      else
        nil
      end
    end
  end
end
