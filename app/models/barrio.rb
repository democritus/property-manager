class Barrio < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true,
    :scope => :country
  
  default_scope :order => 'barrios.country_id ASC, barrios.province_id ASC' +
    ', barrios.name ASC'

  belongs_to :country
  belongs_to :zone
  belongs_to :province
  belongs_to :market
  belongs_to :canton
  has_many :properties
 
  validates_numericality_of :country_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :zone_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :province_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :market_id,
    :only_integer => true,
    :message => "{{value}} must be an integer",
    :allow_nil => true
  validates_numericality_of :canton_id,
    :only_integer => true,
    :message => "{{value}} must be an integer",
    :allow_nil => true
  validates_uniqueness_of :name, :scope => :market_id
  validates_uniqueness_of :name, :scope => :canton_id
#  validates_format_of :name, :with => /^[a-zA-Z0-9\s]+$/,
#    :message => "may only contain letters and numbers"
  
  # TODO: figure out if place is in country
  # see APP/config/initializers/custom_validation.rb
  # Country ID and Province ID are redundant in barrios table for indexing
  # and easier queries. These validations ensure that selected values agree
  # with values in parent
  validates_same_parent(:zone_id, :country)
  validates_same_parent(:province_id, :country)
  validates_same_parent(:market_id, :country)
  validates_same_parent(:canton_id, :country)
  validates_same_parent(:canton_id, :province)
  
  #
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
