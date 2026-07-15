extends Node2D

@onready var brickObject = preload("res://scenes/brick.tscn")
@onready var WallScene = preload("res://scenes/wall.tscn")

var leftWall
var rightWall
var topWall

var columns = 12
var rows = 7
var brick_margin = 50
var wall_margin = 100

const BRICKSIZE := 34

func _ready() -> void:
	create_walls()
	setupLevel()
	
func create_walls():
	var screen = get_viewport_rect().size
	var thickness = 50

	# Left wall
	leftWall = WallScene.instantiate()
	add_child(leftWall)
	leftWall.position = Vector2(0, screen.y / 2)
	leftWall.setup_wall(Vector2(thickness, screen.y))

	# Right wall
	rightWall = WallScene.instantiate()
	add_child(rightWall)
	rightWall.position = Vector2(screen.x, screen.y / 2)
	rightWall.setup_wall(Vector2(thickness, screen.y))

	# Top wall
	topWall = WallScene.instantiate()
	add_child(topWall)
	topWall.position = Vector2(screen.x / 2, 0)
	topWall.setup_wall(Vector2(screen.x, thickness))
	
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


func _on_deathzone_body_entered(body: Node2D) -> void:
	if body.is_in_group("balls"):
		body.destroyed.emit()
		body.queue_free()

	body.queue_free()
