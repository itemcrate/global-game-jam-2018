extends Node2D

enum GAME_STATE {
	PLAYING,
	PROCESSING,
	END
}

var code
var display = ""
var game_state = PLAYING
var game_won = false
var inputs
var inputedKeys = []
var options = ["Up","Down","Left", "Right"]
var required = []
var text = ""

func _ready():
	code = get_node("Code")
	inputs = get_node("Inputs")

	display = "Match the inputs!"

	var index = 0
	while index < 4:
		required.append(options[randi() % 4])
		index += 1
		
	for key in required:
		if required.back() == key:
			text += key
		else:
			text += key + " "
	code.set_text(text)

	set_process_input(true)

	set_process(true)

func _process(delta):
	if game_state == PROCESSING and inputedKeys.size() == 4:
		if code.get_text() == inputs.get_text():
			display = "You've matched the code!"
			game_won = true
		else:
			display = "You entered the code wrong!"
		game_state = END


func _input(event):
	if game_state == PLAYING:
		game_state = PROCESSING

	elif game_state == PROCESSING and event.is_pressed():
		if options.has(event.as_text()):
			inputedKeys.append(event.as_text())

			var textToAdd = event.as_text()

			if inputedKeys.size() < 4:
				textToAdd += " "

			inputs.set_text(inputs.get_text() + textToAdd)