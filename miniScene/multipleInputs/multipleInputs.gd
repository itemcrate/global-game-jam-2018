extends Node2D

enum GAME_STATE {
	PLAYING,
	PROCESSING,
	END
}

var code
var converted_options = {
	"Enter": "A",
	"Escape": "B",
	"Select": "Y"
}

var display = ""
var game_state = PLAYING
var game_won = false
var inputs
var inputedKeys = ""
var options = ["A","B","X", "Y"]
var optionsToConvert = ["Enter", "Escape", "Select"]
var required = []
var text = ""

func _ready():
	code = get_node("Code")
	inputs = get_node("Inputs")

	display = "Enter the code!"

	var index = 0
	while index < 4:
		required.append(options[randi() % 4])
		index += 1
		
	for key in required:
		text += key
	code.set_text(text)

	set_process_input(true)

	set_process(true)

func _process(delta):
	if game_state == PROCESSING and inputs.get_text().length() == 4:
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
		var textToAdd = ""

		if optionsToConvert.has(event.as_text()):
			textToAdd = converted_options[event.as_text()]
		else:
			textToAdd = event.as_text()

		if options.has(textToAdd):
			inputedKeys += textToAdd
			inputs.set_text(inputedKeys)