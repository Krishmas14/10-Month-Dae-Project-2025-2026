extends KinematicBody2D

export var id = 0
export var speed = 250

var velocity = Vector2()
var is_dashing = false
var dash_timer = 0.0
var dash_velocity = Vector2()

var is_minimized = false
var normal_speed = 250
var minimized_speed = 400
var normal_scale = Vector2(1, 1)
var minimized_scale = Vector2(0.5, 0.5)

# Dash function with parameters
func dash(distance, duration):
	if is_dashing:
		return # Prevent dash if already dashing
	var dir = velocity.normalized()
	if dir == Vector2.ZERO:
		dir = Vector2(1, 0) # Default dash right if standing still
	
	dash_velocity = dir * (distance / duration)
	dash_timer = duration
	is_dashing = true

# Minimize function with parameters
func minimize(new_scale, new_speed):
	is_minimized = !is_minimized
	if is_minimized:
		scale = new_scale
		speed = new_speed
	else:
		scale = normal_scale
		speed = normal_speed

func _input(event):
	if event.is_action_pressed('scroll_up'):
		$Camera2D.zoom -= Vector2(0.1, 0.1)
	if event.is_action_pressed('scroll_down'):
		$Camera2D.zoom += Vector2(0.1, 0.1)

	# Dash called later in function
	if event.is_action_pressed("dash"):
		print("Dash key pressed — calling dash function now")
		dash(200, 0.15) # Dash 200 pixels in 0.15 seconds

	# Minimize toggle on "F"
	if event.is_action_pressed("minimize"):
		minimize(minimized_scale, minimized_speed)

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	if is_dashing:
		move_and_slide(dash_velocity)
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	else:
		get_input()
		move_and_slide(velocity)
