extends CharacterBody2D

const BallScene = preload("res://scenes/bol.tscn")

@export var shoot_delay := 1
var can_shoot := true

const PADDLE_SPEED = 1000

var touch_active := false
var touch_position := Vector2.ZERO

func shoot():
	if !can_shoot:
		return
	if GameManager.available_balls <= 0:
		return

	can_shoot = false
	$ShootCooldown.start()

	var ball = BallScene.instantiate()

	ball.global_position = $BallSpawn.global_position
	ball.velocity = Vector2(0, -ball.speed)

	ball.destroyed.connect(GameManager.ball_destroyed)

	get_tree().current_scene.add_child(ball)

	GameManager.ball_spawned()

func _on_shoot_cooldown_timeout():
	can_shoot = true

func _input(event):
	if event is InputEventScreenTouch:
		touch_active = event.pressed
		if event.pressed:
			touch_position = event.position
	
	elif event is InputEventScreenDrag:
		touch_position = event.position
		
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			shoot()

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
		velocity.x = direction * PADDLE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, PADDLE_SPEED)
		
	move_and_slide()

func _ready():
	$ShootCooldown.wait_time = shoot_delay
