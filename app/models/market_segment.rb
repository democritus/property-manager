class MarketSegment < ActiveRecord::Base

  attr_accessible :name, :position
  
  has_friendly_id :name, :reserved => ['new', 'index']
  
  has_many :agencies
  has_many :market_segment_images, :as => :imageable, :order => 'position ASC'
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :name, :with => /^[a-zA-Z0-9\s]+$/,
    :message => "may only contain letters and numbers"
end

