class_name DamageOverlay extends CanvasLayer

@export var player: PlayerController
@export var flash_duration: float = 1.2

@onready var _color_rect: ColorRect = $ColorRect

var _material: ShaderMaterial
var _tween: Tween


func _ready() -> void:
	_material = _color_rect.material as ShaderMaterial
	var fear_damage: FearDamage = player.get_node("FearDamage")
	fear_damage.damage_dealt.connect(_on_damage_dealt)

func _on_damage_dealt(amount: int) -> void:
	# Fear damage is 2-5. Map it to a flash strength of 0.5-1.0.
	var intensity: float = remap(amount, 2.0, 5.0, 0.5, 1.0)
	flash(intensity)

func flash(intensity: float = 1.0) -> void:
	if _tween:
		_tween.kill() # stop the previous fade if a new hit arrives
	_material.set_shader_parameter("flash_strength", intensity)
	_tween = create_tween()
	_tween.tween_property(_material, "shader_parameter/flash_strength", 0.0, flash_duration) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func set_permanent_strength(value: float) -> void:
	_material.set_shader_parameter("permanent_strength", clampf(value, 0.0, 1.0))