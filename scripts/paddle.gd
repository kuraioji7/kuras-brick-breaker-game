extends CharacterBody2D

const SPEED = 1000

var touch_active := false
var touch_position := Vector2.ZERO

func _input(event):
	if event is InputEventScreenTouch:
		touch_active = event.pressed
		if event.pressed:
			touch_position = event.position
	
	elif event is InputEventScreenDrag:
		touch_position = event.position

func _physics_process(delta: float) -> void:
	# If keyboard inputs
	var direction := Input.get_axis("ui_left", "ui_right")
	
	# If touch is active, override keyboard direction
	if touch_active:
		if abs(touch_position.x - global_position.x) > 10:
			if touch_position.x > global_position.x:
				direction = 1
			else:
				direction = -1
		else:
			direction = 0
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
