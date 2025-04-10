extends CharacterBody2D

@export var speed = 75.0

@onready var animated_sprite = $AnimatedSprite2D

var last_direction = Vector2.RIGHT  # Store last direction as a Vector2
var is_activating = false
var last_input_device = "keyboard"  # Can be "keyboard" or "controller"

func _ready():
	# Enable mouse input
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	# Check for mouse movement
	if event is InputEventMouseMotion:
		last_input_device = "keyboard"

func _physics_process(delta):
	if is_activating:
		return  # Don't process movement while activating
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	# Check if input is from controller or keyboard
	if Input.is_action_pressed("right") or Input.is_action_pressed("left") or \
	   Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		last_input_device = "controller"
	elif Input.is_action_pressed("right") or Input.is_action_pressed("left") or \
		 Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		last_input_device = "keyboard"
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * speed
		animated_sprite.play("walk")
		
		# Update last_direction if moving horizontally
		if input_vector.x != 0:
			last_direction = Vector2(sign(input_vector.x), 0)
		
		# Flip sprite based on horizontal direction
		if input_vector.x < 0:
			animated_sprite.flip_h = true
		elif input_vector.x > 0:
			animated_sprite.flip_h = false
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		animated_sprite.play("idle")
	
	# Always keep the last horizontal direction for idle animation
	animated_sprite.flip_h = (last_direction.x < 0)
	
	move_and_slide()
	
	# Check for activate action
	if Input.is_action_just_pressed("activate"):
		activate()

func activate():
	is_activating = true
	
	if last_input_device == "keyboard":
		# Get the direction to the mouse
		var mouse_direction = get_mouse_direction()
		# Set the sprite direction based on mouse position
		animated_sprite.flip_h = (mouse_direction.x < 0)
		# Update last_direction based on the activation direction
		last_direction = Vector2(sign(mouse_direction.x), 0)
	else:
		# Use the last known direction for controller input
		animated_sprite.flip_h = (last_direction.x < 0)
	
	animated_sprite.play("activate")
	# Wait for the animation to finish
	await animated_sprite.animation_finished
	is_activating = false
	
	# Return to previous state
	if velocity != Vector2.ZERO:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

func get_mouse_direction() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	return direction.normalized()
