// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require leaflet.js
//= require_tree .


window.onload = function () {
		L.Icon.Default.imagePath = 'images/';
		var lat;
		var lng;
		var map;
		var results;
		var pins = L.layerGroup();

		if (navigator.geolocation) {
    	navigator.geolocation.getCurrentPosition(setPosition, setDefault);
    }

    $("form").on("submit", function(event) {
			event.preventDefault();
			getPins();
			$(":focus").blur();
		});

		$("#use-address").click(function() {
			$("#location").val(address);
			$("form").submit();
		})

    function setPosition(position){
		  lat = position.coords.latitude;
		  lng = position.coords.longitude;
		  showMap(lat, lng);
			getAddress(lat, lng)
		}

		function setDefault(position){
		  lat = 37.7833;
		  lng = -122.4167;
		  showMap(lat, lng);
		  $("#location").val("San Francisco");
		  $("#use-address").hide();
		}

		function showMap(lat, lng) {
			map = L.map('map').setView([lat, lng], 14);
    	L.tileLayer('http://{s}.tile.cloudmade.com/115a3b4c774c4af1a44d2d3c39bc134c/998/256/{z}/{x}/{y}.png', 
    	{attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'}).addTo(map);
		};

		function getAddress(lat, lng) {
			var latlng = lat + "," + lng;
			var address
			$.ajax({
			    type: "GET",
			    url: "http://maps.googleapis.com/maps/api/geocode/json",
			    data: {latlng: latlng, sensor: true},
			    dataType: 'json',
			    success: function (response) { 
			    	city = response["results"][0]["address_components"][3]["long_name"];
			    	address = response["results"][0]["formatted_address"];
			    	$("#location").val(city);
			    }
			});
		}

    function getPins() {
    	pins.clearLayers();
    	$.ajax({
			    type: "GET",
			    url: "/places.json",
			    data: {term: $("#placeName").val(), location: $("#location").val()},
			    dataType: 'json',
			    success: function (response) { 
			    	var businesses = response["businesses"]
			    	businesses_array = []
			      for (var i = 0; i < businesses.length; i++) {
							var marker = L.marker([businesses[i]["lat"], businesses[i]["lng"]]).bindPopup(
								"<strong>" + businesses[i]["name"] + "</strong>"
								 + "<br/>" +
								businesses[i]["location"]["address"][0]
								 + "<br/>" +
								businesses[i]["message"]);
							businesses_array.push(marker);
						};
						pins = L.layerGroup(businesses_array).addTo(map);
						businesses_array[0].openPopup();
						map.setView([businesses[0]["lat"], businesses[0]["lng"]], 15);
			    }
			});
    }
    
};