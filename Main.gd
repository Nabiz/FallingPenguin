extends Node2D

export (PackedScene) var Platform
var screen_size
var platforms = []
var speed = 100

func _ready():
	screen_size = get_viewport_rect().size
	randomize()

func spawn_platform():
	var spawn_position = Vector2(rand_range(0, screen_size.x - $Platform/ColorRect.margin_right), screen_size.y)
	var platform = Platform.instance()
	add_child(platform)
	platform.set_speed(speed)
	platform.position = spawn_position
	platforms.append(platform)

func _on_Timer_timeout():
	spawn_platform()

func _on_SpeedTimer_timeout():
	print("SZYBCIEJ!!!")
	$Timer.wait_time /= 1.25
	speed *= 1.5
	for platform in platforms:
		platform.set_speed(speed)
