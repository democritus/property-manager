class AgencyJurisdiction < ActiveRecord::Base

  belongs_to :agency
  belongs_to :market
  
  after_update :enforce_one_primary_market_per_agency

  
  private
  
  def enforce_one_primary_market_per_agency
    unless self.primary_market.nil?
      if self.primary_market
        self.agency.agency_jurisdictions.update_all(
          { :primary_market => false },
          [ '`id` <> ?', self.id ]
        )
      end
    end
  end
end

