namespace :cache do 
  desc 'Sweep Cache' 
  task :sweep => :environment do 
    puts "Sweeping cache..." 
    SiteSweeper::sweep 
  end 
end
