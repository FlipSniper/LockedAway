extends CharacterBody3D

var speed = 3.5
const JUMP_VELOCITY = 4.5
var crouching = false
var look_sensitivity = 0.005
var camera_pitch := 0.0

@onready var head = $head

var controls_enabled = true

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if controls_enabled and event is InputEventMouseMotion and Inventory.mouse_lock:
		rotation.y -= event.relative.x * look_sensitivity
		camera_pitch = clamp(camera_pitch - event.relative.y, 1.2, 1.2)
		head.rotation.x = camera_pitch

func _process(delta: float) -> void:
	if controls_enabled:
		if Input.is_action_just_pressed("crouch"):
			crouching = !crouching
		speed = 1.25 if crouching else 3.5
