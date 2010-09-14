class MarketImage < Image
  
  acts_as_fleximage do
    image_directory 'public/seed_images/market_images'
    use_creation_date_based_directories false
    image_storage_format :png
    #output_image_jpg_quality 85
    
    # Validation
    require_image true
    validates_image_size '400x0'
    missing_image_message 'is required'
    invalid_image_message 'was not a readable image'
    
    # Default path to image if no image uploaded
    #default_image_path
    
    # Default image to create if no image uploaded
    #default_image
    
    preprocess_image do |image|
      image.resize '1024x768'
    end
  end
  
  default_scope :include => nil
  
  #validates_presence_of :caption
end
