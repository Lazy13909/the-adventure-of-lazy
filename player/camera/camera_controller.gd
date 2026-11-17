extends Node3D

@export var min_limit_x: float = -30
@export var max_limit_x: float = 20
@export var horizontal_acceleration: float = 2.0
@export var vertical_acceleration: float = 1.0
@export var mouse_acceleration = 0.008

@export_group("Crouch")
@export var player: PlayerController
@export var crouch_pivot_height: float = 0.5
@export var crouch_max_limit_x: float = 25.0
@export var crouch_transition_time: float = 0.3

var _stand_pivot_height: float
var _stand_max_limit_x: float
var _tween: Tween

func _physics_process(delta: float) -> void:
	var joystick_direction = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	rotate_from_vector(joystick_direction * delta * Vector2(horizontal_acceleration, vertical_acceleration))

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_stand_pivot_height = position.y
	_stand_max_limit_x = max_limit_x
	player.crouch_changed.connect(_on_player_crouch_changed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_visible"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("mouse_captured"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_from_vector(event.relative * mouse_acceleration)

func rotate_from_vector(vector: Vector2):
	if vector.length() == 0: return
	rotation.y -= vector.x
	rotation.x -= vector.y
	rotation.x = clamp(rotation.x, deg_to_rad(min_limit_x), deg_to_rad(max_limit_x))

func _on_player_crouch_changed(crouching: bool) -> void:
	max_limit_x = crouch_max_limit_x if crouching else _stand_max_limit_x
	var target_y: float = crouch_pivot_height if crouching else _stand_pivot_height

	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)
	_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "position:y", target_y, crouch_transition_time)

	# When standing up, bring the camera back inside the normal limit.
	var limit_rad: float = deg_to_rad(max_limit_x)
	if rotation.x > limit_rad:
		_tween.tween_property(self, "rotation:x", limit_rad, crouch_transition_time)
