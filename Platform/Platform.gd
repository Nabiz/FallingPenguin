extends StaticBody2D

var speed = 100
var scored = false

signal touched_by_player

func _process(delta):
    position.y -= speed * delta

func set_speed(new_speed):
    speed = new_speed


func _on_VisibilityNotifier2D_screen_exited():
    queue_free()


func _on_ScoreArea_body_entered(body):
    if scored == false and body.is_on_floor():
        scored = true
        emit_signal("touched_by_player")
