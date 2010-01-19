class AgencyRelationship < ActiveRecord::Base

  belongs_to :agency, :foreign_key => :partner_id
end
