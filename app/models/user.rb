class User < ActiveRecord::Base
  # Authentication (installed as gem)
  # for available options see documentation in: Authlogic::ActsAsAuthentic
  acts_as_authentic
  #acts_as_authentic # do |c|
  #  c.my_config_option = my_value
  #end # block optional

  belongs_to :nationality,
    :class_name => 'Country'
    
  #has_one :administrator
  has_one :agent
  
  has_many :information_receipts,
    :class_name => 'InformationRequest',
    :primary_key => 'email',
    :foreign_key => 'recipient_email'
  has_many :information_requests, :order => 'created DESC'
  has_many :user_icons, :as => :imageable, :order => 'position ASC'

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :email, :login
end

