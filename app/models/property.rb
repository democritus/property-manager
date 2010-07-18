class Property < ActiveRecord::Base
  
  include AssignablePseudoFields
  
  belongs_to :agency
  belongs_to :barrio, :include => true
  
#  has_one :canton, :through => :barrio
#  has_one :market, :through => :barrio

  has_one :primary_category, :through => :category_assignments,
    :source => :category,
    :conditions => 'primary_category = 1'
  has_one :primary_style, :through => :style_assignments,
    :source => :style,
    :conditions => 'primary_style = 1'
  has_many :listings
  has_many :property_images, :as => :imageable, :order => 'position ASC'
  has_many :category_assignments, :as => :category_assignable, 
    :order => 'primary_category DESC'
  has_many :categories, :through => :category_assignments, 
    :order => 'category_assignments.primary_category DESC'
  has_many :feature_assignments, :as => :feature_assignable, 
    :order => 'highlighted_feature DESC'
  has_many :features, :through => :feature_assignments, 
    :order => 'feature_assignments.highlighted_feature DESC'
  has_many :style_assignments, :as => :style_assignable, 
    :order => 'primary_style DESC'
  has_many :styles, :through => :style_assignments, 
    :order => 'style_assignments.primary_style DESC'

  validates_presence_of :name
#  validates_format_of :name, :with => /^[a-zA-Z0-9\s]+$/,
#    :message => "may only contain letters and numbers"
  validates_numericality_of :agency_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :barrio_id,
    :allow_blank => true,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :bathroom_number,
    :allow_blank => true
  validates_numericality_of :bedroom_number,
    :allow_blank => true,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :construction_size,
    :allow_blank => true,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :land_size,
    :allow_blank => true,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :parking_spaces,
    :allow_blank => true,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :stories,
    :allow_blank => true,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :year_built,
    :allow_blank => true,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :legacy_id,
    :allow_nil => true,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  
  # TODO: These are virtual attributes and they fail when doing database
  # migrations. Need to figure way to validate when saving but still allow
  # migrations to work correctly
  # Virtual attributes should be allowed to be nil, but not blank
  #validates_numericality_of :primary_category_id,
  #  :allow_nil => true,
  #  :only_integer => true,
  #  :message => "{{value}} must be an integer"
  #validates_numericality_of :primary_style_id,
  #  :allow_nil => true,
  #  :only_integer => true,
  #  :message => "{{value}} must be an integer"
    
  validate :bathroom_number_must_be_whole_or_half
  
  def bathroom_number_must_be_whole_or_half
    if bathroom_number.nil? then
      return
    else
      # Decimal values have precision problems
      bathTimesTen = (bathroom_number * 10).to_i
      unless (bathTimesTen % 5) == 0
        errors.add(:bathroom_number, ' should be either a whole number or half')
      end
    end
  end  
end
