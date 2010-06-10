class Market < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true,
    :scope => :country
  
  default_scope :order => 'markets.country_id ASC, markets.name ASC'
  
  belongs_to :country
  
  #has_many :administrators, :through => :market_administrations
  has_many :agencies, :through => :agency_jurisdictions, 
    :order => 'agency_jurisdictions.primary_agency DESC'
  has_many :agency_jurisdictions, :order => 'primary_agency DESC'
  has_many :barrios, :order => 'position ASC'
  has_many :market_images, :as => :imageable, :order => 'position ASC'
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :country_id
#  validates_format_of :name, :with => /^[a-zA-Z0-9\s]+$/,
#    :message => "may only contain letters and numbers"
  
  # TODO: These are virtual attributes and they fail when doing database
  # migrations. Need to figure way to validate when saving but still allow
  # migrations to work correctly
  #validates_numericality_of :primary_agency_id,
  #  :allow_nil => true,
  #  :only_integer => true,
  #  :message => "{{value}} must be an integer"
  
  before_save :add_primary_agency_to_agency_ids
  after_save :set_primary_agency
  
  def primary_agency_id
    if read_attribute(:primary_agency_id)
      read_attribute(:primary_agency_id).to_i
    else 
      agency_jurisdiction = self.agency_jurisdictions.find(:first,
        :include => nil,
        # REMOVED because default order is 'primary_agency DESC'
        # :conditions => 'primary_agency = 1',
        :select => 'agency_id'
      )
      return '' if agency_jurisdiction.nil?
      agency_jurisdiction.agency_id
    end
  end
  
  def primary_agency_id=(primary_agency_id)
    write_attribute(:primary_agency_id, primary_agency_id.to_i)
  end
  
  
  private
  
  def add_primary_agency_to_agency_ids
    unless self.primary_agency_id.blank?
      new_ids = self.agency_ids || []
      new_ids << self.primary_agency_id
      self.agency_ids = new_ids
    end
  end
  
  def set_primary_agency
    if self.primary_agency_id
      self.transaction do
        # make sure all other records are marked as not primary
        self.agency_jurisdictions.update_all(
          { :primary_agency => false },
          ['agency_id <> ?', self.primary_agency_id]
        )
        # make previously associated the primary record
        self.agency_jurisdictions.update_all(
          { :primary_agency => true },
          ['agency_id = ?', self.primary_agency_id],
          { :limit => 1 }
        )
      end
    end
  end
end
