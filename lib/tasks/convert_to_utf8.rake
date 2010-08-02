require 'db_to_utf8'

namespace :db do

  namespace :convert do
    
    desc 'Converting database to utf8'
    task :to_utf8 => :environment do 
      convert_db_to_utf8
    end
  end
end
