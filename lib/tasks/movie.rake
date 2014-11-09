namespace :movie do
  desc "TODO"
  task refresh: :environment do
  	puts "----------------Starting Movie Refresh!"
  	Movie.refresh_listings
  	puts "----------------Complete!"
  end

end
