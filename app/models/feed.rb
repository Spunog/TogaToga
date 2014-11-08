class Feed < ActiveRecord::Base
	belongs_to :movie
	serialize :jsonData, JSON
end
