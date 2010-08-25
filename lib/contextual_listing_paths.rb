module ContextualListingPaths
  
  require RequestPath
  
  def self.included(base)
    base.module_eval do
      include ContextualListingPaths::InstanceMethods
      alias_method_chain :listing_path, :context
    end
  end

  module InstanceMethods
    # Use correct path whether in admin (not-cached) or client (cached) mode
    def listing_path_with_context( record_or_hash )
      if request_path_parts.first == 'real_estate'
        real_estate_path( record_or_hash )
      else
        listing_path_without_context( record_or_hash )
      end
    end
  end
end
