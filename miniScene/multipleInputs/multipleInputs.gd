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
var options = ["Up", "Down", "Left", "Right"]
var required = PoolStringArray()
var text = ""
var parent

func _ready():
	randomize()
	code = get_node("Code")
	inputs = get_node("Inputs")
	parent = get_parent()

	display = "Enter the corresponding inputs!"

	var index = 0
	while index < 6:
		required.append(options[randi() % 4])
		index += 1
		
	text = required.join(" ")

	code.set_text(text)

	set_process_input(true)

	set_process(true)

func _process(delta):
	if game_state == PROCESSING and inputedKeys.size() == 6:
		if code.get_text() == inputs.get_text():
			display = "You've matched the code! Keep going!"
			game_won = true
			parent.mini_timer.set_paused(true)
			parent.mini_timer_label.set_text("Hit Space to continue!")
		else:
			display = "You entered the code wrong! Try again!"
		game_state = END


func _input(event):
	if game_state == PLAYING:
		game_state = PROCESSING

	elif game_state == PROCESSING and event.is_pressed():
		if options.has(event.as_text()):
			inputedKeys.append(event.as_text())

			var textToAdd = event.as_text()

			if inputedKeys.size() < 6:
				textToAdd += " "

			inputs.set_text(inputs.get_text() + textToAdd)