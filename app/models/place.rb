class Place < ActiveRecord::Base
  attr_accessible :yelp_id, :average, :reviews, :time, :lat, :lng, :name

  def self.add_stored_data(results)
		results["businesses"].each do |business|
			place = Place.find_by_yelp_id(business["id"])
			if !place
				place = place.create_place(business)
			end
			business["message"] = place.get_message
			business["lat"] = place.lat
			business["lng"] = place.lng
		end
		results
	end

	def create_place(business)
		lat_lng = business.query_lat_lng

		new_place = {
			yelp_id: business["id"],
			name: business["name"],
			time: 0,
			reviews: 0,
			average: 0,
			lat: business.lat,
			lng: business.lng
		}

		Place.create(new_place)
	end

	def self.get_access_token
		consumer_key = "xVaX_WEhuVFCYoI3A4gZtw"
		consumer_secret = "Tkl3m4eTdaw-eexWnnY-PmOMtE8"
		token = "d1IKQQyCJWw8jR-sY_fYawn6UAq6VFPv"
		token_secret = "_04NXtsiG6R5Etfn6rSl0trs-VA"

		api_host = "api.yelp.com"

		consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
		OAuth::AccessToken.new(consumer, token, token_secret)
	end

	def self.get_business(id)
		id = URI::escape(id)
		path = "/v2/business/#{id}"
		JSON.parse((self.get_access_token).get(path).body)
	end

	def get_message()
		if self.reviews == 0
			self["message"] = "This restaurant has not been counted yet."
		else
			self["message"] = "The average wait time is #{self.average} minutes, based on #{self.reviews} counts."
		end
	end

	def self.get_places(term, location)
		search = URI::escape(term)
		location = URI::escape(location)

		path = "/v2/search?&term=#{search}&location=#{location}&category_filter=food,restaurants&limit=20"
		JSON.parse(get_access_token.get(path).body)
	end

	def query_lat_lng()
		address = self["location"]["display_address"][0]
		zip = self["location"]["postal_code"]
		zip ||= self["location"]["city"]

		query = address + " " + zip
		query = query.gsub(/ /, '+')

		result = Typhoeus.get("http://maps.googleapis.com/maps/api/geocode/json?address=#{query}&sensor=true")
		result_hash = JSON.parse(result.body)
		location = result_hash["results"][0]["geometry"]["location"]

		self["lat"] = location["lat"]
		self["lng"] = location["lng"]
	end

end
