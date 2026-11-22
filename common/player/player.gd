class_name Player extends CharacterBody3D
## A first-person controller: mouse look, walk, sprint and jump.
## Speeds are in metres per second. 
## Acceleration, friction and air control are in metres per second, per second: how much speed changes in one second.

@export_group("Look")
## How far the view turns for each pixel the mouse moves, in radians.
@export_range(0.0005, 0.01, 0.0005) var mouse_sensitivity : float = 0.0025
## How far the camera can tilt up or down, in degrees.
@export_range(0.0, 90.0, 1.0) var max_pitch : float = 89.0

@export_group("Move")
@export var walk_speed : float = 5.0
@export var sprint_speed : float = 8.0
## How quickly you reach full speed on the ground.
@export var acceleration : float = 40.0
## How quickly you stop on the ground when you let go.
@export var friction : float = 60.0
## How much you can steer in the air. With no input you keep your speed.
@export var air_control : float = 10.0

@export_group("Jump")
## How high a jump goes, in metres.
@export var jump_height : float = 1.0

@onready var camera : Camera3D = $Camera3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		look(event.screen_relative)
	elif event.is_action_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.is_pressed():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


## Turns the view by how far the mouse moved, in pixels. Left and right turns
## the whole body; up and down only tilts the camera, so walking stays level.
func look(pixels: Vector2) -> void:
	rotate_y(-pixels.x * mouse_sensitivity)
	var limit := deg_to_rad(max_pitch)
	camera.rotation.x = clampf(camera.rotation.x - pixels.y * mouse_sensitivity, -limit, limit)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = sqrt(2.0 * get_gravity().length() * jump_height)

	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := transform.basis * Vector3(input.x, 0.0, input.y)
	var speed := sprint_speed if Input.is_action_pressed("sprint") else walk_speed
	var target := direction * speed

	var rate := acceleration if input else friction
	if not is_on_floor():
		rate = air_control if input else 0.0

	var horizontal := Vector3(velocity.x, 0.0, velocity.z).move_toward(target, rate * delta)
	velocity.x = horizontal.x
	velocity.z = horizontal.z

	move_and_slide()
