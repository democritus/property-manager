# Examples:
# rake db:fix:all_listing_type_associations
# rake db:fix:categories_listing_types
# rake db:fix:features_listing_types
# rake db:fix:styles_listing_types
# rake db:fix:clone_property_assignments
require 'fixer'

namespace :db do

  namespace :fix do
    
    desc 'Fix listing types associations'
    task :listing_type_associations => [
      :categories_listing_types,
      :features_listing_types,
      :styles_listing_types
    ]
    
    desc 'Fix categories - listing types association'
    task :categories_listing_types => :environment do 
      puts 'Fixing categories - listing types associations...'
      fix_categories_listing_types
    end
    
    desc 'Fix features - listing types association'
    task :features_listing_types => :environment do 
      puts 'Fixing features - listing types associations...'
      fix_features_listing_types
    end
    
    desc 'Fix styles - listing types association'
    task :styles_listing_types => :environment do 
      puts 'Fixing styles - listing types associations...'
      fix_styles_listing_types
    end
    
    desc 'Clone property assignments to associated listings'
    task :clone_property_assignments => :environment do 
      puts 'Cloning property assignments to associated listings...'
      clone_property_assignments
    end
  end
end
