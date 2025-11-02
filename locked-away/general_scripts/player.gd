extends CharacterBody3D

var speed = 3.5
const JUMP_VELOCITY = 4.5
var crouching = false
var look_sensitivity = 0.005
var camera_pitch := 0.0

@onready var head = $head
@onready var equipped_item: String = ""
@onready var rng = RandomNumberGenerator.new()
@onready var player_key = $head/key

@export var key_scene : PackedScene

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
		
		if Input.is_action_just_pressed("drop"):
			drop_item()
		
		handle_arrow_look(delta)

func handle_arrow_look(delta: float) -> void:
	var look_x = 0.0
	var look_y = 0.0
	if Inventory.mouse_lock:
		if Input.is_action_just_pressed("look_left"): look_x -= 0.5
		if Input.is_action_just_pressed("look_right"): look_x +=0.5
		if Input.is_action_just_pressed("look_up"): look_y += 0.5
		if Input.is_action_just_pressed("look_down"): look_y -= 0.5
		
		rotation.y -= look_x * look_sensitivity * 10.0
		camera_pitch = clamp(camera_pitch + look_y * look_sensitivity * 10.0, -1.2, 1.2)
		head.rotation.x = camera_pitch

func _physics_process(delta: float) -> void:
	if not controls_enabled:
		return
	if crouching:
		$CollisionShape3D.shape.height = lerp($CollisionShape3D.shape.height, 0.75, 0.2)
	if !crouching:
		$CollisionShape3D.shape.height = lerp($CollisionShape3D.shape.height, 2.0, 0.2)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var direction = Vector3(input_dir.x, 0, input_dir.y)
	
	if direction.length() > 0.01:
		direction = direction.rotated(Vector3.UP, rotation.y).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
	else:
		velocity.x = move_toward(velocity.x, 0, speed * 2)
		velocity.z = move_toward(velocity.z, 0, speed * 2)
	
	move_and_slide()

func equip_item(item_name: String) -> void:
	if item_name == "" or not Inventory:
		return
	if equipped_item != "":
		match equipped_item:
			"KEY": player_key.visible = false
	
	equipped_item = item_name
	
	match item_name:
		"KEY": player_key.visible = true
		_: pass

func drop_item() -> void:
	if equipped_item == "" or not Inventory:
		return
	var scene: PackedScene = null
	
	match equipped_item:
		"KEY": scene = key_scene
		_: scene = null
	
	if scene:
		var dropped = scene.instantiate()
		var spawn_pos = head.global_transform.origin + - head.global_transform.basis.z * 1.2 + Vector3.UP * 0.5
		if dropped is RigidBody3D:
			pass
