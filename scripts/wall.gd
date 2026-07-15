extends Node2D

@onready var collision = $StaticBody2D/CollisionShape2D
@onready var sprite = $Sprite2D


func setup_wall(size: Vector2):
	var rect = RectangleShape2D.new()
	rect.size = size
	collision.shape = rect

	# Center sprite on wall
	sprite.centered = true

	# Scale sprite to wall size
	var tex_size = sprite.texture.get_size()
	sprite.scale = size / tex_size
