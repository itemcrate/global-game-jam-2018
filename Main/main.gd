extends Node2D

var current_option = 0
var cursor
var input_options

func _ready():
	cursor = get_node("InputsTexture/Cursor")
	input_options = get_node("InputsTexture/InputsContainer").get_children()
	
	update_cursor()
	
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_left"):
		current_option = (current_option - 1) % input_options.size()
		update_cursor()
	elif event.is_action_pressed("ui_right"):
		current_option = (current_option + 1) % input_options.size()
		update_cursor()

func update_cursor():
	cursor.position = input_options[current_option].position + Vector2(15, 100)
