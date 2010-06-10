class ListingType < ActiveRecord::Base

  has_friendly_id :name
  
  named_scope :friendly_id_equals, lambda { |friendly_id|
    { :conditions => { :id => friendly_id } }
  }
  
  has_many :listings
  has_many :category_assignments, :as => :category_assignable
  has_many :categories, :through => :category_assignments
  has_many :feature_assignments, :as => :feature_assignable
  has_many :features, :through => :feature_assignments
  has_many :style_assignments, :as => :style_assignable
  has_many :styles, :through => :style_assignments

  validates_presence_of :name
#  validates_format_of :name, :with => /^[a-zA-Z0-9\s]+$/,
#    :message => "may only contain letters and numbers"
end
