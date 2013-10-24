module PlacesHelper

	def add_stored_data(results)
		results["businesses"].each do |business|
			place = Place.find_by_yelp_id(business["id"])
			if !place
				place = create_place(business)
			end
			business["message"] = get_message(place)
			business["lat"] = place.lat
			business["lng"] = place.lng
		end
		results
	end

	def calculate_time(place, start_time, end_time)
		total_time = place.time + (end_time - start_time)
		total_reviews = place.reviews + 1
		average = total_time / total_reviews / 60_000
		{time: total_time, reviews: total_reviews, average: average}
	end

	def create_place(business)
		lat_lng = query_lat_lng(business)
		lat = lat_lng[0]
		lng = lat_lng[1]

		new_place = {
			yelp_id: business["id"],
			name: business["name"],
			time: 0,
			reviews: 0,
			average: 0,
			lat: lat,
			lng: lng
		}

		Place.create(new_place)
	end

	def get_access_token
		consumer_key = "xVaX_WEhuVFCYoI3A4gZtw"
		consumer_secret = "Tkl3m4eTdaw-eexWnnY-PmOMtE8"
		token = "d1IKQQyCJWw8jR-sY_fYawn6UAq6VFPv"
		token_secret = "_04NXtsiG6R5Etfn6rSl0trs-VA"

		api_host = "api.yelp.com"

		consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
		OAuth::AccessToken.new(consumer, token, token_secret)
	end

	def get_business(id)
		id = URI::escape(id)
		path = "/v2/business/#{id}"
		JSON.parse(get_access_token.get(path).body)
	end

	def get_message(place)
		if place.reviews == 0
			"This restaurant has not been counted yet."
		else
			"The average wait time is #{place.average} minutes, based on #{place.reviews} counts."
		end
	end

	def get_places(term, location)
		search = URI::escape(term)
		location = URI::escape(location)

		path = "/v2/search?&term=#{search}&location=#{location}&category_filter=food,restaurants&limit=10"
		JSON.parse(get_access_token.get(path).body)
	end

	def query_lat_lng(business)
		# binding.pry
		address = business["location"]["display_address"][0]
		zip = business["location"]["postal_code"]
		zip ||= business["location"]["city"]

		query = address + " " + zip
		query = query.gsub(/ /, '+')

		result = Typhoeus.get("http://maps.googleapis.com/maps/api/geocode/json?address=#{query}&sensor=true")
		result_hash = JSON.parse(result.body)
		location = result_hash["results"][0]["geometry"]["location"]

		lat = location["lat"]
		lng = location["lng"]
		
		# postal_code = business["location"]["postal_code"]
		# street_address = business["location"]["display_address"][0]
		# api_key = "416f2db4017e2d5527ac5770515883134cf644ab"
		# request = Typhoeus::Request.get(
		# 	"https://api.locu.com/v1_0/venue/search/",
		# 	params: {
		# 		postal_code: postal_code,
		# 	 	street_address: street_address,
		# 	 	api_key: api_key
		#  	})

		# complete_result = JSON.parse(request.body)
		# relevant_result = complete_result["objects"]

		# if relevant_result.present?
		# 	lat = relevant_result[0]["lat"]
		# 	lng = relevant_result[0]["long"]
		# end

		[lat, lng]
	end

end
