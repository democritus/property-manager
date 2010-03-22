class Listing < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :reserved_words => ['new', 'index']
  
  # will_paginate options
  cattr_reader :per_page
  @@per_page = 2
  
  # Pseudo fields for data stored in associated models
  include AssignablePseudoFields
  
  # Pseudo relationship combining Property and Listing images
  attr_accessor :images
  
  # Scopes
  default_scope :include => {
    :property => { :agency => { :broker => { :user => :user_icons } } } }
  named_scope :with_broker, :include => {
    :property => { :agency => { :broker => { :user => :user_icons } } } }
  named_scope :by_agency, lambda {
    |agency_id| {
      :include => :property,
      :conditions => [ 'properties.agency_id = ?', agency_id ]
    }
  }
  named_scope :featured,
    :include => [:property_images, :property],
    :conditions => '`listings`.`listing_type_id` = 1',
    :order => '`listings`.`property_id`',
    :limit => 7
  
  belongs_to :ask_currency,
    :class_name => 'Currency',
    :foreign_key => 'ask_currency_id'
  belongs_to :close_currency,
    :class_name => 'Currency',
    :foreign_key => 'close_currency_id'
  belongs_to :listing_type
  belongs_to :property, :include => [:agency, :property_images]
  
  has_one :primary_category, :through => :category_assignments,
    :source => :category,
    :conditions => 'primary_category = 1'
  has_one :primary_style, :through => :style_assignments,
    :source => :style,
    :conditions => 'primary_style = 1'
    
  has_many :information_requests, :as => :information_requestable,
    :order => 'created_at DESC'
    
  # This allows images to associated with this listing, in addition to the
  # main images that are associated with the property.
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
    
  validates_presence_of :label
  validates_numericality_of :listing_type_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :property_id,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :ask_amount,
    :allow_blank => true,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :ask_currency_id,
    :allow_blank => true,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :close_amount,
    :allow_blank => true,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_numericality_of :close_currency_id,
    :allow_blank => true,
    :only_integer => true,
    :message => "{{value}} must be an integer"
  validates_uniqueness_of :name, :scope => :property_id
  validates_uniqueness_of :label, :scope => :property_id
  
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
end
