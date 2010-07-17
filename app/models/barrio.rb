class Barrio < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true,
    :scope => :canton
  
  default_scope :order => 'barrios.canton_id ASC, barrios.name ASC'

  belongs_to :canton
  belongs_to :market
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
end
