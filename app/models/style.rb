class Style < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true
  
  has_many :style_assignments
  has_many :listings, :through => :style_assignments,
    :source => :style_assignable,
    :source_type => 'Listing'
  has_many :listing_types, :through => :style_assignments,
    :source => :style_assignable,
    :source_type => 'ListingType'
  has_many :properties, :through => :style_assignments,
    :source => :style_assignable,
    :source_type => 'Property'
  
  validates_format_of :name, :with => /^[a-zA-Z0-9\s]+$/,
    :message => "may only contain letters and numbers"
end
