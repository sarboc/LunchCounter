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
//= require jquery.runner-min.js
//= require_tree .

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
	// $("#placeName").attr("value", "<%= @search %>");
	// $("#location").attr("value", "<%= @location %>");
	var startTime
	var endTime
	$("#runner").runner();
	// $("#cancel-button").hide;
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
		$("#wait-time").attr("value", waitTime);
		$("#time-message").text("Your total wait time was " + waitTime)
	});
})