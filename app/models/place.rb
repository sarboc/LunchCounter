class Place < ActiveRecord::Base
  attr_accessible :yelp_id, :average, :reviews, :time, :lat, :lng
end
