class Agency < ActiveRecord::Base

  has_friendly_id :name, :reserved => ['new', 'index']
  
  belongs_to :broker, :class_name => 'Agent', :foreign_key => :broker_id
  belongs_to :country
  
  has_many :agency_images, :as => :imageable, :order => 'position ASC'
  has_many :agency_jurisdictions, :order => 'primary_market DESC'
  has_many :agency_logos, :as => :imageable, :order => 'position ASC'

  has_many :agency_relationships
  has_many :agent_affiliations
  has_many :agents, :through => :agent_affiliations
  has_many :information_requests, :as => :information_requestable,
    :order => 'created_at DESC'
  has_many :markets, :through => :agency_jurisdictions, 
    :order => 'agency_jurisdictions.primary_market DESC'
  has_many :partner_agencies, :through => :agency_relationships,
    :source => :agency
  has_many :properties
  has_many :site_texts
  
  validates_presence_of :name, :short_name, :domain
  validates_uniqueness_of :name, :short_name
  validates_uniqueness_of :subdomain, :scope => :subdomain,
    :case_sensitive => false,
    :message => 'Subdomain must be unique for given domain'
  validates_numericality_of :country_id,
    :only_integer => true
  validates_numericality_of :broker_id,
    :allow_blank => true,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_exclusion_of :subdomain, :in => %w(www),
    :message => 'Subdomain {{value}} is reserved.'
    
  before_validation :short_name_same_as_name
  before_save :add_primary_market_to_market_ids
  after_save :set_primary_market
  
  def primary_market_id
    if read_attribute(:primary_market_id)
      read_attribute(:primary_market_id).to_i
    else 
      agency_jurisdiction = self.agency_jurisdictions.find(:first,
        :include => nil,
        # REMOVED because default order is 'primary_market DESC'
        # :conditions => 'primary_market = 1',
        :select => 'market_id'
      )
      return '' if agency_jurisdiction.nil?
      agency_jurisdiction.market_id
    end
  end
  
  def primary_market_id=(primary_market_id)
    write_attribute(:primary_market_id, primary_market_id.to_i)
  end
  
  # Trim user info from broker_id so that only integer remains
  def broker_id=(broker_id)
    if broker_id.to_i
      super
    else # string must be comma-delimited with user_id as first item
      agent_info = agent_id.split(', ')
      agent_id = agent_info[0]
      if agent_id.to_i.to_s
        write_attribute(:broker_id, agent_id.to_i)
      end
    end
  end
  
  
  private
  
  def short_name_same_as_name
    if self.short_name.blank?
      unless self.name.blank?
        self.short_name = self.name
      end
    end
  end
  
  def add_primary_market_to_market_ids
    unless self.primary_market_id.blank?
      new_ids = self.market_ids || []
      new_ids << self.primary_market_id
      self.market_ids = new_ids
    end
  end
  
  def set_primary_market
    if self.primary_market_id
      self.transaction do
        # make sure all other records are marked as not primary
        self.agency_jurisdictions.update_all(
          { :primary_market => false },
          ['market_id <> ?', self.primary_market_id]
        )
        # make previously associated the primary record
        self.agency_jurisdictions.update_all(
          { :primary_market => true },
          ['market_id = ?', self.primary_market_id],
          { :limit => 1 }
        )
      end
    end
  end
end

