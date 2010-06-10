class Barrio < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true,
    :scope => :country
  
  default_scope :order => 'barrios.country_id ASC, barrios.province_id ASC' +
    ', barrios.name ASC'

  belongs_to :country
  belongs_to :zone
  belongs_to :province
  belongs_to :market
  
  has_many :properties
 
  validates_numericality_of :country_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :market_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :zone_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :province_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_uniqueness_of :name, :scope => :market_id
  validates_format_of :name, :with => /^[a-zA-Z0-9\s]+$/,
    :message => "may only contain letters and numbers"
  
  # TODO: figure out if place is in country
  # see APP/config/initializers/custom_validation.rb
  #validates_place_belongs_to_country :zone_id
  #validates_place_belongs_to_country :province_id
  #validates_place_belongs_to_country :market_id
  #validate :zone_must_be_in_country
  #def zone_must_be_in_country
  #  debugger
  #  if zone_id && country_id
  #    Zone.find(:first,
  #      :include => nil,
  #      :conditions => [
  #        'id = :x AND country_id = :y',
  #        [zone_id, country_id]
  #      ]
  #    )
  #  end
  #end
end
