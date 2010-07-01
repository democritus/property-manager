class Currency < ActiveRecord::Base

  has_many :countries
  has_many :listings_for_sale,
    :class_name => 'Listing',
    :foreign_key => 'ask_currency_id'
  has_many :listings_closed,
    :class_name => 'Listing',
    :foreign_key => 'close_currency_id'
    
  validates_presence_of :name, :alphabetic_code, :symbol
  validates_uniqueness_of :name, :alphabetic_code, :symbol
  
  # Force code to be uppercase
  def alphabetic_code=(input)
    write_attribute(:alphabetic_code, input.upcase)
  end
end
