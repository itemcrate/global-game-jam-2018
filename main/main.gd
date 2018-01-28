extends Node2D

enum STATE {
	MAIN,
	MINI,
	END
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
var wins = [false, false, false]


var game_button_on_texture = preload("res://assets/input/inputButtonOn.png")

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

	if wins == [true, true, true]:
		$BackgroundMusic.stop()
		game_win()

	update_countdown(timer_label, timer.time_left)

	if timer.time_left == 15:
		display_label.set_text("Time is running out!")

	if timer.time_left == 0:
		current_state = END
		timer.stop()
		display_label.set_text("*Teleports behind you* Tough break, nothing personnel kid.")

	if current_state == MINI:
		update_countdown(mini_timer_label, mini_timer.time_left)

		if mini_scene.display != "":
			display_label.set_text(mini_scene.display)

		if mini_scene.game_state == END:
			mini_timer.set_paused(true)

		if mini_timer.time_left == 0:
			display_label.set_text("Out of time! Gotta try harder!")
			timer.set_wait_time(timer.time_left - 5.0)
			unload_mini_scene()

func _input(event):
	match current_state:
		MINI:
			if event.is_action_pressed("ui_accept") && mini_scene.game_state == END:
				if mini_scene.game_won:
					wins[current_option] = true
					
					input_options[current_option].set_texture(game_button_on_texture)
					display_label.set_text("No! You can't shut me down!")
				else:
					display_label.set_text("I can't be stopped! Just give up!")
				unload_mini_scene()
		MAIN:
			if event.is_action_pressed("ui_left"):
				current_option = (current_option - 1) % input_options.size()
				if current_option == -1:
					current_option = input_options.size() - 1
				update_cursor()
			elif event.is_action_pressed("ui_right"):
				current_option = (current_option + 1) % input_options.size()
				update_cursor()

			if event.is_action_pressed("ui_accept"):
				load_mini_scene()

func game_win():
	timer.set_paused(true)
	display_label.set_text("Sending shutdown signal. Earth is saved.")

func update_cursor():
	cursor.position = input_options[current_option].position + Vector2(15, 5)

func load_mini_scene():
	var mini_scenes = [
		"res://miniScene/rockPaperScissors/rockPaperScissors.tscn",
		"res://miniScene/pushButton/pushButtonMini.tscn",
		"res://miniScene/multipleInputs/multipleInputs.tscn"
	]

	if wins[current_option]:
		display_label.set_text("You already cracked this part of the shutdown signal, keep going!")
	else:
		var scene = ResourceLoader.load(mini_scenes[current_option])

		mini_scene = scene.instance()
		mini_scene.position = Vector2(0, 300)

		add_child(mini_scene)

		current_state = MINI
		input_container.hide()
		cursor.hide()

		mini_timer.set_wait_time(5.0)
		mini_timer.start()
		mini_timer_label.show()

func unload_mini_scene():
	mini_scene.queue_free()
	mini_timer.stop()
	mini_timer_label.hide()
	current_state = MAIN
	input_container.show()
	cursor.show()

func update_countdown(label, seconds):
	var display_text = String(seconds).split(".")[0]
	label.set_text(display_text)
