extends KinematicBody2D

const GRAVITY = 200.0
const WALK_SPEED = 200

var velocity = Vector2()
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	if is_on_floor():
		velocity.y = 0
	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0
	move_and_slide(velocity, Vector2(0, -1))
	position.x = clamp(position.x, 0, screen_size.x-$ColorRect.margin_right)

