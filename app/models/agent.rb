class Agent < ActiveRecord::Base

  belongs_to :user
  
  has_many :agencies, :through => :agent_affiliations, 
    :order => 'primary_agency DESC'
  has_many :agent_affiliations
  has_many :brokered_agencies, :class_name => 'Agency', :foreign_key => :broker_id
  
  accepts_nested_attributes_for :agent_affiliations
  
  # TODO: Fix user_id AJAX lookup so that only the integer is stored in user_id
  #validates_numericality_of :user_id,
  #  :only_integer => true
  validates_presence_of :user_id
  
  # Trim user info from user_id so that only integer remains
  def user_id=(user_id)
    if user_id.to_i.to_s
      super
    else # string must be comma-delimited with user_id as first item
      user_info = user_id.split(', ')
      user_id = user_info[0]
      if user_id.to_i.to_s
        write_attribute(:user_id, user_id.to_i)
      end
    end
  end
end

