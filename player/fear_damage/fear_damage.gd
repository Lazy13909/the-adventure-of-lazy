class_name FearDamage extends Node

signal damage_dealt(amount: int)

@export var player: PlayerController
@export var min_damage: int = 2
@export var max_damage: int = 5
@export var min_interval: float = 30.0
@export var max_interval: float = 60.0

@onready var timer: Timer = $Timer

func _ready() -> void:
    timer.one_shot = true
    timer.timeout.connect(_on_timer_timeout)

func start_fear_damage() -> void:
    if not timer.is_stopped():
        return
    _schedule_next()

# Not used yet. Needed for the ending and the lose condition.
func stop_fear_damage() -> void:
    timer.stop()

func _schedule_next() -> void:
    timer.start(randf_range(min_interval, max_interval))

func _on_timer_timeout() -> void:
    var amount: int = randi_range(min_damage, max_damage)
    player.health -= amount
    damage_dealt.emit(amount)
    _schedule_next()