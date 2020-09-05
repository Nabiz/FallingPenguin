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
    for i in range(5):
        if scored == true:
            break
        elif body.is_on_floor():
            scored = true
            emit_signal("touched_by_player")
            break
        else:
            yield(get_tree().create_timer(0.1), "timeout")   
