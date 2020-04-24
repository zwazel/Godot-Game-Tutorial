extends KinematicBody

export var GRAVITY = -24.8 # Our gravity
export var MAX_SPEED = 20 # The fastest speed we can reach. Once we hit this speed, we will not go any faster.
export var JUMP_SPEED = 18 # How high we can jump.
export var ACCEL = 4.5 # How quickly we accelerate. The higher the value, the sooner we get to max speed.
export var MAX_SPRINT_SPEED = 40
export var SPRINT_ACCEL = 18
var is_sprinting = false
var dir = Vector3() # Our direction
var vel = Vector3() # Our KinematicBody’s velocity.

export var DEACCEL = 16 # How quickly we are going to decelerate. The higher the value, the sooner we will come to a complete stop.
export var MAX_SLOPE_ANGLE = 40 # The steepest angle our KinematicBody will consider as a ‘floor’.
	
func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	
func process_input(delta):
	# ----------------------------------
	# Walking
	dir = Vector3() # set dir to an empty Vector3, dir is our direction the player intends to move towards
	var input_movement_vector = Vector2()

	if Input.is_action_pressed("vorwärts"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("rückwärts"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("links"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("rechts"):
		input_movement_vector.x += 1

	input_movement_vector = input_movement_vector.normalized()

	# Move in the direction the camera is facing
	dir.z += input_movement_vector.y # Forwards/Backwards
	dir.x += -input_movement_vector.x # Left/Right
	# ----------------------------------

	# Jumping
	if is_on_floor(): # Check if we're on the floor, if we are, we can jump
		if Input.is_action_just_pressed("springen"):
			vel.y = JUMP_SPEED # Set the y axis of our vel(ocity) to jump_speed
	# ----------------------------------
	
	# Sprinting
	if Input.is_action_pressed("sprinten"): # if shift is pressed
		is_sprinting = true # sprint
	else:
		is_sprinting = false
	# ----------------------------------
	
func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	vel.y += delta * GRAVITY # apply gravity
	var hvel = vel # horizontal velocity (horizontal because y is 0)
	hvel.y = 0
	var target = dir

	if is_sprinting:
		target *= MAX_SPRINT_SPEED
	else:
		target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0: # check if we're moving on the x and z axis (y is 0)
		if is_sprinting:
			accel = SPRINT_ACCEL
		else:
			accel = ACCEL
	else: # if we're not moving, start deaccalerating
		accel = DEACCEL 

	hvel = hvel.linear_interpolate(target, accel * delta) # interpolate the horizontal velocity
	vel.x = hvel.x # set the velocity to the interpolated horizontal velocity
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE)) # move
	# deg2rad = degrees converted to radians
