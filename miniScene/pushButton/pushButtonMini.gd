extends Node2D

const SPEED = 10

var button
var direction = Vector2(1, 0)
var hand

func _ready():
	button = get_node("Button")
	hand = get_node("Hand")

	button.position = Vector2(randi() % 700, 0)
	hand.position = Vector2(randi() % 700, 200)

	set_physics_process(true)
	
func _physics_process(delta):
	print(hand.position.x)
	
	if hand.position.x >= 700:
		direction = Vector2(-1, 0)
	elif hand.position.x <= 0:
		direction = Vector2(1, 0)

	hand.position.x += (direction.x * SPEED)
