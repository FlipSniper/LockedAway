extends Node3D

var sensitivity = 0.2
var flashlight

func _ready() -> void:
	flashlight = get_tree().current_scene.get_node("flashlight2")

func _process(delta: float) -> void:
	if player.controls_enabled:
		if Input.is_action_just_pressed("flashlight"):
			flashlight.visible = !flashlight.visible
