class_name InteractionDetector extends RayCast3D

signal target_changed(target: Node3D)

var current_target: Node3D = null

func _ready() -> void:
	add_to_group("interaction_detector")
	add_exception(owner.player)

func _physics_process(_delta: float) -> void:
	var new_target: Node3D = null

	if is_colliding():
		var collider := get_collider() as Node3D
		if collider != null and collider.is_in_group("interactable"):
			new_target = collider

	if new_target != current_target:
		current_target = new_target
		target_changed.emit(current_target)
