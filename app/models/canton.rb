class Canton < ActiveRecord::Base

  attr_accessible :country_id, :province_id, :name, :position, :cached_slug

  belongs_to :country
  belongs_to :province
  has_many :properties
  
  validates_numericality_of :country_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :province_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_uniqueness_of :name, :scope => :province_id
#  validates_format_of :name, :with => /^[a-zA-Z0-9\s]+$/,
#    :message => "may only contain letters and numbers"
  validates_same_parent(:province_id, :country)
end
