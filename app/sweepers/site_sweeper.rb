# Delete entire cache
# http://www.fngtps.com/2006/01/lazy-sweeping-the-rails-page-cache
class SiteSweeper < ActionController::Caching::Sweeper

# DISABLED: Model observer functionality. Instead using controller callbacks
# since domain name is needed from controller scope (request.host)

#  observe Agency, AgencyImage, AgencyJurisdiction, AgencyRelationship, Agent,
#    AgentAffiliation, Barrio, Category, Country, Currency, Feature,
#    FeatureAssignment, Listing, ListingType, Market, MarketImage,
#    MarketSegment, MarketSegmentImage, Property, PropertyImage, Province,
#    SiteText, Style, StyleAssignment, User, UserIcon

#  observe Listing, Property
  
#  # Model callbacks
#  def after_save(record)
#    self.class::sweep
#  end
#  
#  def after_destroy(record)
#    self.class::sweep
#  end
  
  # Controller callbacks
  def after_listings
    subdirectory = request.host
    self.class::sweep(subdirectory)
  end
  
  def self.image_directories
    [
      'agency_images',
      'agency_logos',
      'market_images',
      'market_segment_images',
      'property_images',
      'user_icons'
    ]
  end
  
  def self.sweep( subdirectory = nil )
    cache_dir = ActionController::Base.page_cache_directory
    cache_dir += '/' + subdirectory if subdirectory
    unless cache_dir == RAILS_ROOT + '/public'
      dir = Dir.new(cache_dir)
      dir.each do |filename|
        path = cache_dir + '/' + filename
        unless filename == '.' || filename == '..'
          if File.directory?(path)
            unless self.image_directories.include?(filename)
              #FileUtils.rm_r(Dir.glob(path + '/*')) rescue Errno::ENOENT
              FileUtils.rm_r(path) rescue Errno::ENOENT
              RAILS_DEFAULT_LOGGER.info("Cache directory '#{path}' swept.")
            end
          else
            FileUtils.rm(path)
          end
        end
      end
    end
  end
end
