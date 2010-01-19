class AgencyImage < Image
  
  acts_as_fleximage do
    image_directory 'public/images/agency_images'
    use_creation_date_based_directories false
    image_storage_format :png
    #output_image_jpg_quality 85
    
    # Validation
    require_image true
    validates_image_size '200x100'
    missing_image_message 'is required'
    invalid_image_message 'was not a readable image'
    
    # Default path to image if no image uploaded
    #default_image_path
    
    # Default image to create if no image uploaded
    #default_image
    
    # Don't resize... this is a logo, so it should already be the correct size
    #preprocess_image do |image|
    #  image.resize '640x480'
    #end
  end
  
  default_scope :include => nil
end
