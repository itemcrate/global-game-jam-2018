extends Node2D

const SPEED = 10

enum GAME_STATE {
	PLAYING,
	PROCESSING,
	END
}

var button
var display = ""
var game_state = PLAYING
var direction = Vector2(1, 0)
var game_won = false
var hand

func _ready():
	button = get_node("Button")
	hand = get_node("Hand")

	button.position = Vector2(randi() % 700, 0)
	hand.position = Vector2(randi() % 700, 200)

	display = "Push the button!"

	set_physics_process(true)
	set_process_input(true)
	
func _physics_process(delta):
	match game_state:
		PLAYING:
			if hand.position.x >= 700:
				direction = Vector2(-1, 0)
			elif hand.position.x <= 0:
				direction = Vector2(1, 0)

			hand.position.x += (direction.x * SPEED)
		PROCESSING:
			direction = Vector2(0, -1)
			if hand.position.y > 70:
				hand.position.y -= (1 * SPEED)
			elif not game_won:
				display = "Oh no! You missed the button!"


func _input(event):
	match game_state:
		PLAYING:
			if event.is_action_pressed("ui_accept"):
				game_state = PROCESSING
		PROCESSING:
			if event.is_action_pressed("ui_accept"):
				game_state = END

func _on_Hand_body_entered( body ):
	game_won = true
	display = "Good job! You pushed the button!"
