extends Control

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		var scene = ResourceLoader.load("res://main/main.tscn")
		var instance = scene.instance()
		get_tree().get_root().add_child(instance)
		get_tree().set_current_scene(instance)
