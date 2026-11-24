extends Node

@export var highlight_material: Material

var _highlighted_meshes: Array[MeshInstance3D] = []

func _ready() -> void:
	var detector := get_parent() as InteractionDetector
	if detector == null:
		push_warning("TargetHighlighter: parent is not an InteractionDetector.")
		return
	detector.target_changed.connect(_on_target_changed)

func _on_target_changed(target: Node3D) -> void:
	_clear_highlight()
	if target == null:
		return
	for node in target.find_children("*", "MeshInstance3D", true, false):
		var mesh := node as MeshInstance3D
		mesh.material_overlay = highlight_material
		_highlighted_meshes.append(mesh)

func _clear_highlight() -> void:
	for mesh in _highlighted_meshes:
		if is_instance_valid(mesh):
			mesh.material_overlay = null
	_highlighted_meshes.clear()
