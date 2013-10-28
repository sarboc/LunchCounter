class PlacesController < ApplicationController

	def index
		if params[:location]
			@search = params[:term]
			@location = params[:location]

			@location = "San Francisco" if @location == ""

			@results = Place.get_places(@search, @location)

			@results = Place.add_stored_data(@results)
		end

		respond_to do |format|
			format.html
			format.json { render json: @results }
		end

	end

	def show
		id = params[:id]
		@business = Place.get_business(id)
		place = Place.find_by_yelp_id(id)
		@business["message"] = place.get_message
	end

	def new
		@business = Place.find_by_yelp_id(params[:id])
	end

	def create
		id = params[:id]
		start_time = params[:startTime].to_i
		end_time = params[:endTime].to_i
		place = Place.find_by_yelp_id(id)
		new_data = calculate_time(place, start_time, end_time)
		place.update_attributes(new_data)

		redirect_to "/#{id}"
	end

end
