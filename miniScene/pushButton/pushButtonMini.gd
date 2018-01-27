extends Node2D

const SPEED = 10

enum GAME_STATE {
	PLAYING,
	PROCESSING,
	END
}

var button
var current_state = PLAYING
var direction = Vector2(1, 0)
var hand

func _ready():
	button = get_node("Button")
	hand = get_node("Hand")

	button.position = Vector2(randi() % 700, 0)
	hand.position = Vector2(randi() % 700, 200)

	set_physics_process(true)
	set_process_input(true)
	
func _physics_process(delta):
	match current_state:
		PLAYING:
			if hand.position.x >= 700:
				direction = Vector2(-1, 0)
			elif hand.position.x <= 0:
				direction = Vector2(1, 0)

			hand.position.x += (direction.x * SPEED)
		PROCESSING:
			direction = Vector2(0, -1)
			if hand.position.y > 50:
				hand.position.y -= (1 * SPEED)

func _input(event):
	match current_state:
		PLAYING:
			if event.is_action_pressed("ui_accept"):
				current_state = PROCESSING
		PROCESSING:
			if event.is_action_pressed("ui_accept"):
				current_state = END
