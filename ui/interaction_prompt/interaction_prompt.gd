extends CanvasLayer

@onready var label: Label = $PromptLabel

func _ready() -> void:
	label.visible = false

	await get_tree().process_frame
	var detector := get_tree().get_first_node_in_group("interaction_detector") as InteractionDetector
	if detector == null:
		push_warning("InteractionPrompt: no interaction detector found.")
		return
	detector.target_changed.connect(_on_target_changed)

func _on_target_changed(target: Node3D) -> void:
	label.visible = target != null
