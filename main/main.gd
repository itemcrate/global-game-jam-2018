extends Node2D

enum STATE {
	MAIN,
	MINI
}

enum MINI_STATE {
	PLAYING,
	PROCESSING,
	END
}

var current_state = MAIN
var current_option = 0
var cursor
var display_label
var input_container
var input_options
var mini_scene
var mini_timer
var mini_timer_label
var timer
var timer_label

func _ready():
	cursor = get_node("InputsTexture/Cursor")
	display_label = get_node("GameDisplay/DisplayLabel")
	input_container = get_node("InputsTexture/InputsContainer")
	input_options = get_node("InputsTexture/InputsContainer").get_children()
	mini_timer = get_node("MiniTimer")
	mini_timer_label = get_node("MiniTimer/MiniTimerLabel")
	timer = get_node("Timer")
	timer_label = get_node("Timer/TimerLabel")
	
	timer.start()
	
	update_cursor()
	
	set_process(true)
	set_process_input(true)
	
func _process(delta):
	
	update_countdown(timer.time_left)
	
	if current_state == MINI:
		update_mini_countdown(mini_timer.time_left)

		if mini_scene.display != "":
			display_label.set_text(mini_scene.display)

		if mini_timer.time_left == 0:
			mini_timer.set_wait_time("5.0")
			unload_mini_scene()

func _input(event):
	match current_state:
		MINI:
		 	if event.is_action_pressed("ui_accept") && mini_scene.game_state == END:
		 		unload_mini_scene()
		_:
			if event.is_action_pressed("ui_left"):
				current_option = (current_option - 1) % input_options.size()
				update_cursor()
			elif event.is_action_pressed("ui_right"):
				current_option = (current_option + 1) % input_options.size()
				update_cursor()

			if event.is_action_pressed("ui_accept"):
				load_mini_scene()

func update_cursor():
	cursor.position = input_options[current_option].position + Vector2(15, 100)

func load_mini_scene():
	var mini_scenes = [
		"res://miniScene/rockPaperScissors/rockPaperScissors.tscn",
		"res://miniScene/pushButton/pushButtonMini.tscn"
	]
	var scene = ResourceLoader.load(mini_scenes[current_option])

	mini_scene = scene.instance()
	mini_scene.position = Vector2(0, 300)

	add_child(mini_scene)

	current_state = MINI
	input_container.hide()
	cursor.hide()

	mini_timer.start()
	mini_timer_label.show()

func unload_mini_scene():
	mini_scene.queue_free()
	mini_timer_label.hide()
	current_state = MAIN
	input_container.show()
	cursor.show()
	
func update_mini_countdown(seconds):
	var display_text = String(seconds).split(".")[0]
	mini_timer_label.set_text(display_text)

func update_countdown(seconds):
	var display_text = String(seconds).split(".")[0]
	timer_label.set_text(display_text)
