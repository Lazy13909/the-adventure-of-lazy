class_name JumpZone extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	var player := body as PlayerController
	if player == null:
		return
	player.jump_zone_count += 1

func _on_body_exited(body: Node3D) -> void:
	var player := body as PlayerController
	if player == null:
		return
	player.jump_zone_count -= 1