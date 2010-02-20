class Currency < ActiveRecord::Base

  has_many :listings_for_sale,
    :class_name => 'Listing',
    :foreign_key => 'ask_currency_id'
  has_many :listings_closed,
    :class_name => 'Listing',
    :foreign_key => 'close_currency_id'
    
  validates_presence_of :name, :code, :symbol
  validates_uniqueness_of :name, :code, :symbol
  
  # Force code to be uppercase
  def code=(code)
    write_attribute(:code, code.upcase)
  end
end
