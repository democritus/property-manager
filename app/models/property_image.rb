class PropertyImage < Image
  
  acts_as_fleximage do
    image_directory 'public/source_images/property_images'
    use_creation_date_based_directories true
    image_storage_format :png
    #output_image_jpg_quality 85
    
    # Validation
    require_image true
    validates_image_size '400x0'
    missing_image_message 'is required'
    invalid_image_message 'was not a readable image'
    
    # Default path to image if no image uploaded
    #default_image_path 'public/images/default_property_image.jpg'
    
    # Default image to create if no image uploaded
    #default_image
    
    preprocess_image do |image|
      image.resize '1024x768'
    end
  end
  
  default_scope :include => nil
  
  named_scope :featured,
    :joins => 'INNER JOIN' +
      '(`listings` INNER JOIN `properties` ON `listings`.`property_id` = `properties`.`id`)' +
      ' ON `images`.`imageable_type` = "Property" AND `properties`.`id` = `images`.`imageable_id`' +
        ' OR `images`.`imageable_type` = "Listing" AND `listings`.`id` = `images`.`imageable_id`',
    :order => '`properties`.`id`'
end
