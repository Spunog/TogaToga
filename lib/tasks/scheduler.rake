desc "Movie Update Scheduler"
task :movie_refresh => :environment do
	if [7,12,16,20,23].include?(Time.now.hour)
	  puts "----------------Starting Movie Refresh!"
	  Movie.refresh_listings
	  puts "----------------Complete!"
  	end
end