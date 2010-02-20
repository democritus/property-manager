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
  attr_accessor :intended_recipient_email
  attr_accessor :intended_recipient_name
  
  validates_presence_of :message
  validates_presence_of :name
  validates_presence_of :email
  validates_format_of :email,
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :allow_blank => true
  
  before_save :set_intended_recipient
  
  
  private
  
  # Don't save email recipient since email hasn't been sent yet, but remember
  # the intended recipient so that it can be saved later upon succesful
  # delivery  
  def set_intended_recipient
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
          # Set recipient fields and record in database
          write_attribute(:intended_recipient_email, email)
          write_attribute(:intended_recipient_name, name)
        end
      end
    end
  end
end
