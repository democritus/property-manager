class Style < ActiveRecord::Base

  has_friendly_id :name, :reserved => ['new', 'index']
  
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
end
