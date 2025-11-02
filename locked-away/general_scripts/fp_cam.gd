extends Node3D

var sensitivity = 0.2
var flashlight

@onready var player = get_tree().current_scene.get_node("player")

func _ready() -> void:
	flashlight = get_tree().current_scene.get_node("flashlight2")

func _process(delta: float) -> void:
	if player.controls_enabled:
		if Input.is_action_just_pressed("flashlight"):
			flashlight.visible = !flashlight.visible

func _input(event: InputEvent) -> void:
	if not player.controls_enabled:
		player.rotation_degrees.x = 0
		player.rotation_degrees.y = 0
		player.rotation_degrees.z = 0
		rotation_degrees.x = 0
		rotation_degrees.y =0
		rotation_degrees.z = 0
