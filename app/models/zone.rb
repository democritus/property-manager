class Zone < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true,
    :scope => :country
  
  default_scope :order => 'zones.country_id ASC, zones.name ASC'

  belongs_to :country  
  has_many :barrios, :order => 'position ASC'
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :country_id
#  validates_format_of :name, :with => /^[a-zA-Z0-9\s]+$/,
#    :message => "may only contain letters and numbers"
end
