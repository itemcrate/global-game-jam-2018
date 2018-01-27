extends Node2D

enum STATE {
	MAIN,
	MINI
}

var current_state = MAIN
var current_option = 0
var cursor
var input_container
var input_options
var mini_scene

func _ready():
	cursor = get_node("InputsTexture/Cursor")
	input_container = get_node("InputsTexture/InputsContainer")
	input_options = get_node("InputsTexture/InputsContainer").get_children()
	
	update_cursor()
	
	set_process_input(true)

func _input(event):
	match current_state:
		MINI:
			if event.is_action_pressed("ui_accept"):
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
	var scene = ResourceLoader.load("res://miniScene/pushButton/pushButtonMini.tscn")
	mini_scene = scene.instance()
	mini_scene.position = Vector2(0, 300)

	add_child(mini_scene)
	
	current_state = MINI
	input_container.hide()
	cursor.hide()

func unload_mini_scene():
	mini_scene.queue_free()
	current_state = MAIN
	input_container.show()
	cursor.show()