# Custom page caching:
# 1. Image caching - allow page caching and caching of Fleximage images to be
# enabled/disabled independently (convenient since caching images is so
# resource intensive that turning it off even on the development server is
# rarely desired).
#
# 2. Hostname caching - all page caching is by the host name
#
# NOTE: uses custom configuration constant: APP_CONFIG. These configuration
# should be loaded in initializer 'load_custom_config.rb' which uses
# config/custom_config.yml
module CustomPageCaching  
  
  def self.included( base )
    base.extend( CustomPageCaching::ClassMethods )
    base.class_eval do
      class << self
        alias_method_chain :cache_page, :custom_config
      end
      
      include CustomPageCaching::InstanceMethods
      alias_method_chain :cache_page, :custom_config
    end
  end
  
  module ClassMethods
    # Page caching - check custom configuration variables instead of 
    # built-in Rails configuration
    def cache_page_with_custom_config( content, path )
      return unless APP_CONFIG['perform_page_caching']
      cache_page_without_custom_config( content, path )
    end
    
    def caches_page_with_custom_config( *actions )
      return unless APP_CONFIG['perform_page_caching']
      caches_page_without_custom_config( *actions )
    end
    
    # Fleximage page caching: create caching methods that do exactly the same
    # thing as cache_page and caches_page, except they check the custom
    # configuration setting "perform_fleximage_caching" instead of the built-in
    # Rails "perform_caching"
    def cache_fleximage( content, path )
      return unless perform_caching && APP_CONFIG['perform_fleximage_caching']
      benchmark "Cached page: #{page_cache_file(path)}" do
        FileUtils.makedirs(File.dirname(page_cache_path(path)))
        File.open(page_cache_path(path), "wb+") { |f| f.write(content) }
      end
    end
    
    def caches_fleximage( *actions )
      return unless perform_caching &&
        APP_CONFIG['perform_fleximage_caching']
      options = actions.extract_options!
      after_filter(
        {:only => actions}.merge(options)
      ) { |c| c.cache_fleximage }
    end
  end
  
  module InstanceMethods
    # "cache_page" alias method which effectivly forces the domain name to be
    # pre-pended to the page cache path. Note that the "caches_page" method
    # called on actions within a controller is affected by this as well
    def cache_page_with_custom_config( content = nil, options = nil )
      return unless perform_caching && caching_allowed &&
        APP_CONFIG['perform_page_caching']
      cache_page_without_custom_config( content,
        cache_path_with_hostname(options) )
    end
  
    def cache_fleximage( content = nil, options = nil )
      return unless perform_caching && caching_allowed &&
        APP_CONFIG['perform_fleximage_caching']
      self.class.cache_fleximage(content || response.body,
        cache_path_with_hostname(options) )
    end
    
    
    private
    
    # Insert hostname into path
    def cache_path_with_hostname( options )
      path = "/#{request.host}"
      path << case options
        when Hash
          url_for(
            options.merge(
              :only_path => true,
              :skip_relative_url_root => true,
              :format => params[:format]
            )
          )
        when String
          options
        else
          request.path
      end
      return path
    end
  end
end
