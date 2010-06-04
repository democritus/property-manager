# Delete entire cache
# http://www.fngtps.com/2006/01/lazy-sweeping-the-rails-page-cache
class SiteSweeper < ActionController::Caching::Sweeper

  observe Agency, AgencyImage, AgencyJurisdiction, AgencyRelationship, Agent,
    AgentAffiliation, Barrio, Category, Country, Currency, Feature,
    FeatureAssignment, Listing, ListingType, Market, MarketImage,
    MarketSegment, MarketSegmentImage, Property, PropertyImage, Province,
    SiteText, Style, StyleAssignment, User, UserIcon

  def after_save(record)
    self.class::sweep
  end
  
  def after_destroy(record)
    self.class::sweep
  end
  
  def self.sweep
    # TODO: enable domain-specific cache expiration instead of blowing up the
    # entire cache
    cache_dir = ActionController::Base.page_cache_directory
    unless cache_dir == RAILS_ROOT + '/public'
      FileUtils.rm_r(Dir.glob(cache_dir + "/*")) rescue Errno::ENOENT
      RAILS_DEFAULT_LOGGER.info("Cache directory '#{cache_dir}' fully swept.")
    end
  end
end
