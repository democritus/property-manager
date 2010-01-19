class Category < ActiveRecord::Base

  has_friendly_id :name, :reserved => ['new', 'index']

  has_many :category_assignments
  has_many :listings, :through => :category_assignments,
    :source => :category_assignable,
    :source_type => 'Listing'
  has_many :listing_types, :through => :category_assignments,
    :source => :category_assignable,
    :source_type => 'ListingType'
  has_many :properties, :through => :category_assignments,
    :source => :category_assignable,
    :source_type => 'Property'
end
