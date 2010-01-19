class SiteText < ActiveRecord::Base

  # TODO: why did nifty_scaffold put this here?
  #attr_accessible :agency_id, :name, :value
  
  belongs_to :agencies
  
  validates_presence_of :name, :value
  # TODO: make sure this regex requires that ALL letters be upper case
  validates_format_of :name, :with => /[a-z0-9_]/,
    :message => 'Name must contain only lower-case letters, numbers, or the' +
      ' underscore character'
  validates_uniqueness_of :name, :scope => :agency_id 
  
  before_validation :downcase_underscore_name
  
  
  private
  
  def downcase_underscore_name
    #write_attribute(:name, self.name.downcase.tr(' ', '_'))
    write_attribute(:name, self.name.downcase.gsub(/\s/, '_'))
  end
end
