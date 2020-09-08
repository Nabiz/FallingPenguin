extends Node2D

export (PackedScene) var Platform
var screen_size
var speed = 0
var score = 0
var level = 1


var level_params = {
    1:{'score': 0, 'speed': 100, 'spawn_time': 2},
    2:{'score': 1000, 'speed': 150, 'spawn_time': 1.8},
    3:{'score': 5000, 'speed': 200, 'spawn_time': 1.6},
    4:{'score': 14000, 'speed': 250, 'spawn_time': 1.4},
    5:{'score': 30000, 'speed': 300, 'spawn_time': 1.2},
    6:{'score': 55000, 'speed': 400, 'spawn_time': 1},
    7:{'score': 91000, 'speed': 500, 'spawn_time': 0.8},
    8:{'score': 140000, 'speed': 600, 'spawn_time': 0.7},
    9:{'score': 204000, 'speed': 700, 'spawn_time': 0.65},
    10:{'score': 285000, 'speed': 800, 'spawn_time': 0.6}
   }

func _ready():
    screen_size = get_viewport_rect().size
    $Platform.set_speed(0)
    $Player.walk_speed = 0
    speed = 100
    randomize()

func _process(_delta):
    if level < 10:
        if score >= level_params[level+1]['score']:
            level_up()

func _on_SpawnTimer_timeout():
    var platform = Platform.instance()
    add_child(platform)
    var spawn_position = Vector2(rand_range(
    0, screen_size.x - $Platform/ColorRect.margin_right), screen_size.y)
    platform.set_speed(speed)
    platform.position = spawn_position
    platform.connect(
        "touched_by_player", get_node("."), "_on_Platform_touched_by_player")

func level_up():
    level += 1
    $SpawnTimer.wait_time = level_params[level]['spawn_time']
    speed = level_params[level]['speed']
    $HUD.update_level(level)
    for child in get_children():
        if 'Platform' in child.name:
            child.set_speed(speed)

func _on_HUD_start_game():
    $SpawnTimer.start()
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
