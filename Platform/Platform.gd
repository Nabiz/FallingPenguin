extends StaticBody2D

var speed = 100

func _process(delta):
	position.y -= speed * delta

func set_speed(new_speed):
	speed = new_speed
