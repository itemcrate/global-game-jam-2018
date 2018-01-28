extends Control

var game_loaded = false

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept") && !game_loaded:
		game_loaded = true
		var scene = ResourceLoader.load("res://main/main.tscn")
		var instance = scene.instance()
		get_tree().get_root().add_child(instance)
		get_tree().set_current_scene(instance)
