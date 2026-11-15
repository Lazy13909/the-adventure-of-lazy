extends CanvasLayer

@export var player: PlayerController

@onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/HealthBar
@onready var stamina_bar: ProgressBar = $MarginContainer/VBoxContainer/StaminaBar

func _ready() -> void:
	if player == null:
		push_error("HUD: the player is not assigned in the Inspector.")
		return

	# Show the correct values right away
	_on_health_changed(player.health, player.max_health)
	_on_stamina_changed(player.stamina, player.max_stamina)

	# Listen for future changes
	player.health_changed.connect(_on_health_changed)
	player.stamina_changed.connect(_on_stamina_changed)

func _on_health_changed(current: float, maximum: float) -> void:
	health_bar.max_value = maximum
	health_bar.value = current


func _on_stamina_changed(current: float, maximum: float) -> void:
	stamina_bar.max_value = maximum
	stamina_bar.value = current