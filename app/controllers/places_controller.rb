class PlacesController < ApplicationController
	# require "oauth"

	def index
		if params[:term]
			@raw_search = params[:term]
			@search = URI::escape(@raw_search)
			@raw_location = params[:location]
			@location = URI::escape(@raw_location)
			path = "/v2/search?&term=#{@search}&location=#{@location}&limit=5"
			@results = JSON.parse(get_access_token.get(path).body)

			@results["businesses"].each do |business|
				business["message"] = get_counter(business["id"])
			end
		end
	end

	def show
		business = URI::escape(params[:id])
		path = "/v2/business/#{business}"
		@business = JSON.parse(get_access_token.get(path).body)
		@message = get_counter(params[:id])
	end

	def new
		@id = params[:id]
	end

	def create
		id = params[:id]
		start_time = params[:startTime].to_i
		end_time = params[:endTime].to_i

		place = Place.find_by_yelp_id(id)

		if place
			total_time = place.time + (end_time - start_time)
			total_reviews = place.reviews + 1
			average = total_time / total_reviews / 60_000
			place.update_attributes(time: total_time, reviews: total_reviews, average: average)
		else
			time = end_time - start_time
			reviews = 1
			average = time / 60_000
			Place.create(yelp_id: id, time: time, reviews: reviews, average: average)
		end

		redirect_to "/#{id}"
	end

end
