class Barrio < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true,
    :scope => :country
  
  default_scope :order => 'barrios.canton_id ASC, barrios.name ASC'

  belongs_to :market
  belongs_to :canton
  has_many :properties
 
  validates_numericality_of :canton_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :market_id,
    :only_integer => true,
    :message => "{{value}} must be an integer",
    :allow_nil => true
  validates_uniqueness_of :name, :scope => :market_id
  validates_uniqueness_of :name, :scope => :canton_id
#  validates_format_of :name, :with => /^[a-zA-Z0-9\s]+$/,
#    :message => "may only contain letters and numbers"
end
