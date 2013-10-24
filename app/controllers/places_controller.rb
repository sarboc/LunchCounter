class PlacesController < ApplicationController
	# require "oauth"

	def index
		if params[:term]
			@search = params[:term]
			@location = params[:location]

			# @search = "sandwich" if @search == ""
			@location = "San Francisco" if @location == ""

			@results = get_places(@search, @location)

			@results = add_stored_data(@results)
		end

		respond_to do |format|
			format.html
			format.json { render json: @results }
		end

	end

	def show
		id = params[:id]
		@business = get_business(id)
		place = Place.find_by_yelp_id(id)
		@business["message"] = get_message(place)
	end

	def new
		@id = params[:id]
	end

	def create
		id = params[:id]
		start_time = params[:startTime].to_i
		end_time = params[:endTime].to_i

		place = Place.find_by_yelp_id(id)
		new_data = calculate_time(place, start_time, end_time)
		place.update_attributes(new_data)

		# if place
		# 	total_time = place.time + (end_time - start_time)
		# 	total_reviews = place.reviews + 1
		# 	average = total_time / total_reviews / 60_000
		# 	place.update_attributes(time: total_time, reviews: total_reviews, average: average)
		# else
		# 	time = end_time - start_time
		# 	reviews = 1
		# 	average = time / 60_000
		# 	Place.create(yelp_id: id, time: time, reviews: reviews, average: average)
		# end

		redirect_to "/#{id}"
	end

end
