extends KinematicBody2D

var gravity = 400.0
var walk_speed = 200.0

var velocity = Vector2()
var screen_size

func _ready():
    screen_size = get_viewport_rect().size

func _physics_process(delta):
    velocity.y += delta * gravity
    if is_on_floor():
        velocity.y = 0
    if Input.is_action_pressed("ui_left"):
        velocity.x = -walk_speed
    elif Input.is_action_pressed("ui_right"):
        velocity.x =  walk_speed
    else:
        velocity.x = 0
    _play_aanimation()
    move_and_slide(velocity, Vector2(0, -1))
    position.x = clamp(position.x, 0, screen_size.x-$ColorRect.margin_right)

func _play_aanimation():
    if velocity.x < 0:
        $AnimatedSprite.flip_h = true
        $AnimatedSprite.play()
    elif velocity.x > 0:
        $AnimatedSprite.flip_h = false
        $AnimatedSprite.play()
    else:
       $AnimatedSprite.stop() 
