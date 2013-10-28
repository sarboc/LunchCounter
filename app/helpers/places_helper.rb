module PlacesHelper

	def calculate_time(place, start_time, end_time)
		total_time = place.time + (end_time - start_time)
		total_reviews = place.reviews + 1
		average = total_time / total_reviews / 60_000
		{time: total_time, reviews: total_reviews, average: average}
	end

end
