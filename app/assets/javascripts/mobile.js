//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery.runner-min.js

function formatTimeOfDay(millisSinceEpoch) {
  var secondsSinceEpoch = (millisSinceEpoch / 1000) | 0;
  var secondsInDay = ((secondsSinceEpoch % 86400) + 86400) % 86400;
  var seconds = secondsInDay % 60;
  var minutes = ((secondsInDay / 60) | 0) % 60;
  var hours = (secondsInDay / 3600) | 0;
  return hours + (minutes < 10 ? ":0" : ":")
      + minutes + (seconds < 10 ? ":0" : ":")
      + seconds;
}

function disableButton(button) {
	$(button).removeClass("btn-primary");
	$(button).addClass("btn-info");
	$(button).attr("disabled", "disabled");
}

function enableButton(button) {
	$(button).removeProp("disabled");
	$(button).show();
}

$(document).ready(function() {
	var address;
	var city;
	var startTime;
	var endTime;

	$("#use-address").click(function() {
			$("#location").val(address);
			$("form").submit();
		})

	if (navigator.geolocation) {
  	navigator.geolocation.getCurrentPosition(setPosition, setDefault);
  }

  function setPosition(position){
	  lat = position.coords.latitude;
	  lng = position.coords.longitude;
		getAddress(lat, lng)
	}

	function setDefault(position){
	  $("#location").val("San Francisco");
	  $("#use-address").hide();
	}

	function getAddress(lat, lng) {
		var latlng = lat + "," + lng;
		$.ajax({
		    type: "GET",
		    url: "http://maps.googleapis.com/maps/api/geocode/json",
		    data: {latlng: latlng, sensor: true},
		    dataType: 'json',
		    success: function (response) { 
		    	city = response["results"][0]["address_components"][3]["long_name"];
		    	address = response["results"][0]["formatted_address"];
		    	$("#location").val(city);
		    	// $("form").submit();
		    }
		});
	}

	$("#runner").runner();

	$("#start-button").click(function() {
		startTime = $.now();
		$("#start-time").attr("value", startTime);
		$("#runner").runner('start');
		disableButton("#start-button");
		enableButton("#order-button");
	});

	$("#order-button").click(function() {
		$("#order-time").attr("value", $.now());
		disableButton("#order-button");
		enableButton("#end-button");
	});

	$("#end-button").click(function() {
		$("#runner").runner('stop');
		endTime = $.now();
		$("#end-time").attr("value", endTime);
		disableButton("#end-button");
		$("#runner").hide();
		$("#end-button").hide();
		$("#order-button").hide();
		$("#start-button").hide();
		$("#cancel-button").show();
		$("#save-button").attr("type", "submit");
		waitTime = formatTimeOfDay(endTime - startTime);
		$("#time-message").text("Your total wait time was " + waitTime)
	});

	})