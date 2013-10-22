module PlacesHelper
	def get_access_token
		consumer_key = "xVaX_WEhuVFCYoI3A4gZtw"
		consumer_secret = "Tkl3m4eTdaw-eexWnnY-PmOMtE8"
		token = "d1IKQQyCJWw8jR-sY_fYawn6UAq6VFPv"
		token_secret = "_04NXtsiG6R5Etfn6rSl0trs-VA"

		api_host = "api.yelp.com"

		consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
		OAuth::AccessToken.new(consumer, token, token_secret)
	end

	def get_counter(id)
		counter = Place.find_by_yelp_id(id)
		if counter
			"The average wait time is #{counter.average} minutes, based on #{counter.reviews} counts."
		else
			"This restaurant has not been counted yet. Be the first!"
		end
	end
end
