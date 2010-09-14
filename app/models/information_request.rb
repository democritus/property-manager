class InformationRequest < ActiveRecord::Base

  belongs_to :information_requestable, :polymorphic => true
  # TODO: get polymorphic associations working
  #belongs_to :agency
  #belongs_to :listing, :include => [
  #  {:agency => {:broker => :user}},
  #  {:property => {:barrio => [:market, :country]}}
  #]
  belongs_to :contact,
    :class_name => 'User',
    :foreign_key => 'recipient_email'
  belongs_to :user
  
  # Pseudo fields
  attr_accessor :subject
  attr_accessor :recipient_email
  attr_accessor :recipient_name
  
  validates_presence_of :message
  validates_presence_of :name
  validates_presence_of :email
  validates_format_of :email,
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :allow_blank => true
  
  before_save :set_recipient
  
  
  private
  
  # Remember the intended recipient so that it can be mailed by model observer
  def set_recipient
    return nil unless self.agency_id
    agency = Agency.find( self.agency_id, :include => { :broker => :user } )
    if agency
      if agency.broker
        if agency.broker.user
          agency.broker.user
          email = agency.broker.user[:email]
          unless agency.broker.user[:name].blank?
            name = agency.broker.user[:name]
          else
            name = agency[:name]
          end
          # Set recipient fields
          write_attribute(:recipient_email, email)
          write_attribute(:recipient_name, name)
        end
      end
    end
  end
end
