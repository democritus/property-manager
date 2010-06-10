class Feature < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true

  has_many :feature_assignments
  has_many :listings, :through => :feature_assignments,
    :source => :feature_assignable,
    :source_type => 'Listing'
  has_many :listing_types, :through => :feature_assignments,
    :source => :feature_assignable,
    :source_type => 'ListingType'
  has_many :properties, :through => :feature_assignments,
    :source => :feature_assignable,
    :source_type => 'Property'
    
  validates_presence_of :name
  validates_format_of :name, :with => /^[a-zA-Z0-9\s]+$/,
    :message => "may only contain letters and numbers"
end
