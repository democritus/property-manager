class Feature < ActiveRecord::Base

  has_friendly_id :name, :reserved => ['new', 'index']

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
end
