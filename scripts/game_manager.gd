extends Node

var score = 0
var level = 1

var active_balls := 0
var available_balls := 5
var max_balls := 5

var reload_time := 10.0

func add_points(points):
	score += points

func ball_spawned():
	active_balls += 1
	available_balls -= 1
	
func ball_destroyed():
	active_balls -= 1

	if active_balls <= 0 and available_balls <= 0:
		game_over()

	reload_ball()

func reload_ball():
	await get_tree().create_timer(reload_time).timeout

	if available_balls < max_balls:
		available_balls += 1

func game_over():
	score = 0
	get_tree().reload_current_scene()

func _process(delta: float) -> void:
	$CanvasLayer/ScoreLabel.text = str(score)
	$CanvasLayer/LevelLabel.text = "Level: " + str(level)
