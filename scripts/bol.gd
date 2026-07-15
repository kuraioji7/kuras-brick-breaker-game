extends CharacterBody2D

var speed = 200.0
var dir = Vector2.DOWN
signal destroyed

#func _ready():
	#add_to_group("balls")
	
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		# Need to change this logic later on to have varing speed after collision
		velocity = velocity.bounce(collision.get_normal()).normalized() * speed
		
		# If it is going too straight up
		if abs(velocity.x) < 10:
			velocity.x += randf_range(-20, 20)
			velocity = velocity.normalized() * speed
		
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()
