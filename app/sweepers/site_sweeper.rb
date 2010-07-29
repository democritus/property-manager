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
  
  # Exclude files and directories to be skipped when sweeping. For example,
  # if routes for images generated with Fleximage plugin are namespaced to
  # "images", then skip this directory so that they don't have to be
  # regenerated.
  def self.exclude_paths
    [
      'images'
    ]
  end
  
  def self.sweep( subdirectory = nil, exclude_paths_to_ignore = [] )
    cache_dir = ActionController::Base.page_cache_directory
    cache_dir += '/' + subdirectory if subdirectory
    unless cache_dir == RAILS_ROOT + '/public'
      dir = Dir.new(cache_dir)
      dir.each do |filename|
        path = cache_dir + '/' + filename
        skip_path = false
        if self.exclude_paths.include?( filename )
          # Skip path unless it is explicitly listed in exclude_paths_to_ignore
          # array
          skip_path = true unless exclude_paths_to_ignore.include?( path )
        end
        debugger
        unless filename == '.' || filename == '..'
          if File.directory?( path )
            unless skip_path
              #FileUtils.rm_r( Dir.glob(path + '/*') ) rescue Errno::ENOENT
              #FileUtils.rm_r( path ) rescue Errno::ENOENT
              RAILS_DEFAULT_LOGGER.info( "Cache directory '#{path}' swept." )
            end
          else
            FileUtils.rm(path)
          end
        end
      end
    end
  end
end
