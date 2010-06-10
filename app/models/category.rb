class Category < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true

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
    
  validates_format_of :name, :with => /^[a-zA-Z0-9\s]+$/,
    :message => "may only contain letters and numbers"
end
