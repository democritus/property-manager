class Canton < ActiveRecord::Base

  attr_accessible :province_id, :zone_id, :name, :position, :cached_slug
  
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true,
    :scope => :province

  belongs_to :province
  belongs_to :zone
#  has_one :country, :through => :province
  has_many :barrios, :order => 'position ASC'
  
  validates_numericality_of :province_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :zone_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_uniqueness_of :name, :scope => :province_id
#  validates_format_of :name, :with => /^[a-zA-Z0-9\s]+$/,
#    :message => "may only contain letters and numbers"
end
