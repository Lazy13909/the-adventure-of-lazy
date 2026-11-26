class_name Interactable extends StaticBody3D

signal interacted

func _ready() -> void:
	add_to_group("interactable")

func interact() -> void:
	interacted.emit()
	_on_interact()

func _on_interact() -> void:
	print("Interacted with: ", name)
