extends Node2D

export (PackedScene) var Platform
var screen_size
var speed
var score = 0
var level = 1

func _ready():
    screen_size = get_viewport_rect().size
    $Platform.set_speed(0)
    $Player.walk_speed = 0
    speed = 100
    randomize()

func _on_SpawnTimer_timeout():
    var platform = Platform.instance()
    add_child(platform)
    var spawn_position = Vector2(rand_range(
    0, screen_size.x - $Platform/ColorRect.margin_right), screen_size.y)
    platform.set_speed(speed)
    platform.position = spawn_position
    platform.connect(
        "touched_by_player", get_node("."), "_on_Platform_touched_by_player")

func _on_SpeedTimer_timeout():
    $SpawnTimer.wait_time /= 1.25
    speed *= 1.5
    level += 1
    $HUD.update_level(level)
    for child in get_children():
        if 'Platform' in child.name:
            child.set_speed(speed)

func _on_HUD_start_game():
    $SpawnTimer.start()
    $SpeedTimer.start()
    $Player.walk_speed = 400
    $Player.gravity = 400
    $Platform.set_speed(speed)
    $HUD.show_message("Get Ready")
    $HUD.update_level(level)
    $BackgroundStreamPlayer.play()

func _on_DeathZone_body_entered(_body):
    $Player.walk_speed = 0
    $Player.gravity = 0
    $SpawnTimer.stop()
    $SpeedTimer.stop()
    $HUD.show_game_over()
    speed = 0
    for child in get_children():
        if 'Platform' in child.name:
            child.set_speed(0)
    yield(get_tree().create_timer(3), "timeout")
# warning-ignore:return_value_discarded
    get_tree().reload_current_scene()


func _on_Platform_touched_by_player():
    score += 100 * level
    $HUD.update_score(score)
    $ScoreStreamPlayer.play()
    $ScoreStreamPlayer.stop()
