extends Node

signal inventory_updated()
signal slot_unlocked(new_total_slots)

var mouse_lock = true
@onready var max_slots: int = 8
@onready var unlocked_slots: int = 1

var slots: Array = []

func _ready():
	slots.resize(max_slots)
	for i in range(max_slots):
		slots[i] = null

func unlock_slot() -> void:
	if unlocked_slots < max_slots:
		unlocked_slots += 1
		emit_signal("slot_unlocked", unlocked_slots)
		print("Unlocked slot ", unlocked_slots, "/", max_slots)
