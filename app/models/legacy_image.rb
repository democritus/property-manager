class LegacyImage < LegacyBase

  set_table_name 'real_estate_listing_images'
  set_primary_key 'ImageID'
  
  belongs_to :legacy_listing, :foreign_key => 'PropertyID'
  belongs_to :legacy_property, :foreign_key => 'PropertyID'
    
  def map
    {
#      :property_id => self.propertyid,
      :name => self.imagename,
      :image_filename => new_image_filename,
      :caption => self.caption,
      :position => self.ordernum,
      
      # Source image path (not saved to database)      
      :image_file => path_to_image_file
    }
  end
  
  
  private
  
  def new_image_filename
    possible_filenames = [
      self.imagename + '_original.' + self.imagetype,
      self.imagename + '.' + self.imagetype
    ]
    possible_filenames.each do |possible_filename|
      file = File.new(old_property_images_directory + possible_filename)
      if file.exists?
        filename = possible_filename
        break
      end
    end
    return filename
  end
  
  def old_images_root
    if RAILS_ENV = 'production'
      '/var/www/old.barrioearth.com/www/images/real_estate_listing/'
    else
      '/home/brian/Sites/old.barrioearth.com/www/images/real_estate_listing/'
    end
  end
  
  def old_property_images_directory
    old_image_root + self.propertyid.to_s + '/images/'
  end
end
