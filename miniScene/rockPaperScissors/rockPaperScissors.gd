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
	randomize()
	cursor = get_node("Cursor")
	rps_container = get_node("RPSContainer")
	rps_options = get_node("RPSContainer").get_children()
	parent = get_parent()
	
	display = "Beat Compy at Rock, Paper, Scissors!! Make your choice before the time runs out!"
	
	update_cursor()

func _input(event):
	if game_state == PLAYING:
		if event.is_action_pressed("ui_accept"):
			decide_game()	
		elif event.is_action_pressed("ui_left"):
			current_option = (current_option - 1) % rps_options.size()
			if current_option == -1:
				current_option = rps_options.size() - 1
			update_cursor()
		elif event.is_action_pressed("ui_right"):
			current_option = (current_option + 1) % rps_options.size()
			update_cursor()
	elif game_state == PROCESSING:
		if event.is_action_pressed("ui_accept"):
			game_state = END

func decide_game():
	var pc_choice_label = ""
	
	parent.mini_timer.set_paused(true)
	parent.mini_timer_label.set_text("Hit Space to continue!")
	game_state = PROCESSING
	pc_choice = randi() % 3
	
	match pc_choice: 
		ROCK: 
			pc_choice_label = "rock"
			game_won = current_option == PAPER
		PAPER:
			pc_choice_label = "paper"
			game_won = current_option == SCISSORS
		SCISSORS:
			pc_choice_label = "scissors"
			game_won = current_option == ROCK
	
	display = "Computer picks " + pc_choice_label + "! "
	
	if game_won:
		display += "Shutdown.rps initialized!"
	else:
		display += "The world is doomed! Try again!"
	
func update_cursor():
	cursor.position = rps_options[current_option].position + Vector2(15, 100)
	
