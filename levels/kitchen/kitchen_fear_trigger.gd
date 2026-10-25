extends Area3D

var _has_triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node3D) -> void:
	if _has_triggered:
		return

	if not body is PlayerController:
		return

	var fear_damage := body.get_node_or_null("FearDamage") as FearDamage
	if fear_damage == null:
		push_error("KitchenFearTrigger: Player has no FearDamage child node.")
		return

	_has_triggered = true
	fear_damage.start_fear_damage()
	print("Fear damage started: player entered the Kitchen.")
