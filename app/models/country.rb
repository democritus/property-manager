class Country < ActiveRecord::Base

  has_friendly_id :name, :reserved => ['new', 'index']
  
  has_many :agencies
  has_many :barrios, :order => 'province_id ASC'
  has_many :markets, :order => 'position ASC'
  has_many :provinces, :order => 'position ASC'
  has_many :users, :foreign_key => 'nationality_id'
  has_many :zones, :order => 'position ASC'
  
  # Force ISO2 to be lowercase
  def iso2=(iso2)
    write_attribute(:iso2, iso2.downcase)
  end
end

