"use strict";


function UpdateTitanCountdown(data) {
	var temp_text = ""
    temp_text += data.string

	$("#TimerTextBlock").text = $.Localize(temp_text) + " " + data.time_string
	$("#TimerTextBlock").style.color = data.color
}


(function() {
    GameEvents.Subscribe("titan_countdown_update", UpdateTitanCountdown);
 
    $("#TimerTextBlock").text = $.Localize("#titan_timer_before")
})();
