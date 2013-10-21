module PlacesHelper
	def get_access_token
		search = URI::escape(params[:term])
		location = URI::escape(params[:location])

		consumer_key = "xVaX_WEhuVFCYoI3A4gZtw"
		consumer_secret = "Tkl3m4eTdaw-eexWnnY-PmOMtE8"
		token = "d1IKQQyCJWw8jR-sY_fYawn6UAq6VFPv"
		token_secret = "_04NXtsiG6R5Etfn6rSl0trs-VA"

		api_host = "api.yelp.com"

		consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
		OAuth::AccessToken.new(consumer, token, token_secret)
	end
end
