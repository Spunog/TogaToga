desc "Movie Update Scheduler"
task :movie_refresh => :environment do
  puts "----------------Starting Movie Refresh!"
  Movie.refresh_listings
  puts "----------------Complete!"
end