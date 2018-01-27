extends Node2D

enum GAME_STATE {
	PLAYING,
	PROCESSING,
	END	
}

enum GAME_CHOICE {
	ROCK,
	PAPER,
	SCISSORS
}

var current_option = 0
var cursor
var display = ""
var game_state = PLAYING
var game_won = true
var rps_container
var rps_options
var parent
var pc_choice


func _ready():
	cursor = get_node("Cursor")
	rps_container = get_node("RPSContainer")
	rps_options = get_node("RPSContainer").get_children()
	parent = get_parent()
	
	display = "Defeat the computer!"
	
	update_cursor()
	
	set_process_input(true)

func _process(delta):
	if game_state == END:
		pass # Emit signal to end game

func _input(event):
	if game_state == PLAYING:
		if event.is_action_pressed("ui_accept"):
			decide_game()	
		elif event.is_action_pressed("ui_left"):
			current_option = (current_option - 1) % rps_options.size()
			update_cursor()
		elif event.is_action_pressed("ui_right"):
			current_option = (current_option + 1) % rps_options.size()
			update_cursor()

func decide_game():
	var pc_choice_label = ""
	
	game_state = PROCESSING
	pc_choice = randi() % 2
	
	match pc_choice: 
		ROCK: 
			pc_choice_label = "rock"
			if current_option != PAPER:
				game_won = false
		PAPER:
			pc_choice_label = "paper"
			if current_option != SCISSORS:
				game_won = false
		SCISSORS:
			pc_choice_label = "scissors"
			if current_option != ROCK:
				game_won = false
	
	var display_label = "Computer picks " + pc_choice_label + "! "
	
	if game_won:
		display_label += "A winner is you!"
	else:
		display_label += "The world is doomed!"
		
	display = display_label
	
	game_state = END
		
	
func update_cursor():
	cursor.position = rps_options[current_option].position + Vector2(15, 100)
	
