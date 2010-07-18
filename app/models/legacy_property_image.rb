class LegacyPropertyImage < LegacyBase

  set_table_name 'real_estate_listing_images'
  set_primary_key 'ImageID'
  
  belongs_to :legacy_listing, :foreign_key => 'PropertyID'
  belongs_to :legacy_property, :foreign_key => 'PropertyID'
  
  def map
    {
      :imageable_id => new_property_id,
      :imageable_type => 'Property',

      :caption => self.Caption,
      :position => self.OrderNum, 
      
      # Source image path (not saved to database)
      :image_file => new_image_file
    }
  end
  
  
  private
  
  def new_image_file
    File.new( new_image[1], 'r' )
  end
  
  def new_image
    stem, extension = self.ImageName.split('.')
    possible_filenames = [
      stem + '_original.' + extension,
      self.ImageName
    ]
    filename = nil
    path = nil
    possible_filenames.each do |possible_filename|
      path = old_property_images_directory + possible_filename
      if File.exist?( path )
#        logger.debug 'file found: ' + path
        filename = possible_filename
        break
      end
    end
    unless filename
      logger.debug 'images not found: ' + possible_filenames.join(' & ')
      return default image
    end
    [ filename, path ]
  end
  
  def default_image
    filename = 'default_property_image.jpg'
    common_path = 'public/images/' + filename
    if RAILS_ENV == 'production'
      path = '/u/apps/barrioearth.com/' + common_path
    else
      path = '/home/brian/Sites/barrioearth.com/' + common_path
    end
    return [ filename, path ]
  end
  
  def old_images_root
    if RAILS_ENV == 'production'
      '/var/www/old.barrioearth.com/www/images/real_estate_listing/'
    else
      '/home/brian/Sites/old.barrioearth.com/www/images/real_estate_listing/'
    end
  end
  
  def old_property_images_directory
    old_images_root + self.PropertyID.to_s + '/images/'
  end
end
