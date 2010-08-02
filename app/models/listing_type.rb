class ListingType < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true
  
  named_scope :friendly_id_equals, lambda { |friendly_id|
    { :conditions => { :id => friendly_id } }
  }
  
  has_many :listings
  has_many :category_assignments, :as => :category_assignable,
    :order => 'category_assignments.primary_category DESC' + 
      ', category_assignments.highlighted DESC'
  has_many :categories, :through => :category_assignments,
    :order => 'category_assignments.primary_category DESC' + 
      ', category_assignments.highlighted DESC'
  has_many :feature_assignments, :as => :feature_assignable, 
    :order => 'feature_assignments.highlighted DESC'
  has_many :features, :through => :feature_assignments, 
    :order => 'feature_assignments.highlighted DESC'
  has_many :style_assignments, :as => :style_assignable,
    :order => 'style_assignments.primary_style DESC' +
      ', style_assignments.highlighted DESC'
  has_many :styles, :through => :style_assignments,
    :order => 'style_assignments.primary_style DESC' +
      ', style_assignments.highlighted DESC'

  validates_presence_of :name
#  validates_format_of :name, :with => /^[a-zA-Z0-9\s]+$/,
#    :message => "may only contain letters and numbers"
end
