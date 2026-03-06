extends Node2D

@onready var brickObject = preload("res://scenes/brick.tscn")
@onready var leftWall = $Walls/LeftWall
@onready var rightWall = $Walls/RightWall

var columns = 32
var rows = 7
var brick_margin = 50
var wall_margin = 100

const BRICKSIZE := 34

func _ready() -> void:
	setupLevel()

func setupLevel():
	var colors = getColors()
	colors.shuffle()
	
	var screen_width = get_viewport_rect().size.x
	
	var play_area_left = wall_margin
	var play_area_right = screen_width - wall_margin
	var play_area_width = play_area_right - play_area_left
	
	# Move walls
	leftWall.position.x = play_area_left
	rightWall.position.x = play_area_right

	# Calculate brick spacing dynamically
	var total_brick_width = columns * BRICKSIZE
	var start_x = play_area_left + (play_area_width - total_brick_width) / 2.0
	
	for row in rows:
		for column in columns:
			var newBrick = brickObject.instantiate()
			add_child(newBrick)
			
			newBrick.position = Vector2(
				start_x + (BRICKSIZE * column), 
				brick_margin + (BRICKSIZE * row)
			)

			var sprite = newBrick.get_node('Sprite2D')
			var color_index = int(row * 4 / rows)
			sprite.modulate = colors[color_index]

				
func _process(delta: float) -> void:
	pass
	
func getColors():
	var colors = [
		Color(0.0, 0.544, 0.71, 1.0),
		Color(0.75, 0.0, 0.0, 1.0),
		Color(0.118, 0.71, 0.0, 1.0),
		Color(0.91, 0.758, 0.0, 1.0),
	]
	return colors
