extends KinematicBody

export var GRAVITY = -24.8
export var MAX_SPEED = 20
export var JUMP_SPEED = 18
export var ACCEL = 4.5
export var MAX_SPRINT_SPEED = 40
export var SPRINT_ACCEL = 18
var is_sprinting = false
var dir = Vector3()
var vel = Vector3()
var hat_key = false
var respawn_point = Vector3(0,2.5,0)
var last_checkpoint = null

export var DEACCEL = 16
export var MAX_SLOPE_ANGLE = 40

export var MOUSE_SENSITIVITY = 0.05

onready var camera = $Kopf/Camera
onready var kopf = $Kopf
onready var ray = $Kopf/RayCast

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	
func process_input(delta):
	var cam_xform = camera.get_global_transform()
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

	dir += -cam_xform.basis.z * input_movement_vector.y # Forwards/Backwards
	dir += cam_xform.basis.x * input_movement_vector.x # Left/Right
	# ----------------------------------

	# Jumping/Springen
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
	
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"): # if we press esc
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE: # if the mouse mode is already set to visible
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # set the mouse mode to invisible/captured
		else: # if the mouse mode is already invisible/captured
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # set the mouse mode to visible
	# ----------------------------------
	
	# open/close door
	if Input.is_action_just_pressed("interact"):
		var coll = ray.get_collider()
		if ray.is_colliding() and coll.has_method("open_door"):
			coll.open_door(hat_key)
	
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

	var accel # schlussendliche beschleunigung
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

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		kopf.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		
		var camera_rot = kopf.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		kopf.rotation_degrees = camera_rot
 
func kill():
	self.global_transform.origin = respawn_point
	
func set_checkpoint(pos, object):
	respawn_point = pos
	if last_checkpoint:
		last_checkpoint.is_current_checkpoint = false
	last_checkpoint = object
	object.is_current_checkpoint = true


