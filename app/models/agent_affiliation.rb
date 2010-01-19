class AgentAffiliation < ActiveRecord::Base

  belongs_to :agent
  belongs_to :agency

  after_update :enforce_one_primary_agency_per_agent
    
  
  private
  
  def enforce_one_primary_agency_per_agent
    unless self.primary_agency.nil?
      if self.primary_agency
        self.agent.agent_affiliations.update_all(
          { :primary_agency => false },
          [ '`id` <> ?', self.id ]
        )
      end
    end
  end
end

