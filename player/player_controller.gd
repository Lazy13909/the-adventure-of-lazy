class_name PlayerController extends CharacterBody3D

signal health_changed(current: float, maximum: float)
signal stamina_changed(current: float, maximum: float)

@export var max_health: float = 100.0

var health: float = 100.0:
	set(value):
		var new_value: float = clampf(value, 0.0, max_health)
		if new_value == health:
			return
		health = new_value
		health_changed.emit(health, max_health)

@onready var state_machine = $StateMachine
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var skin = $Erika
@onready var animation_player = $Erika/AnimationPlayer

@onready var camera_controller: Camera3D = $CameraController/Camera3D

var movement_input: Vector2 = Vector2.ZERO
var vel_2d: Vector2 = Vector2.ZERO

var jump_height: float = 0.7
var jump_time_to_peak: float = 0.4
var jump_time_to_descent: float = 0.3

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var is_crouching: bool
const STANDING_HEIGHT: float = 1.8
const CROUCH_HEIGHT: float = 1.2

@export_group("Stamina")
@export var max_stamina: float = 100.0
@export var run_drain_per_second: float = 17.5
@export var regen_standing_per_second: float = 20.0
@export var regen_walking_per_second: float = 8.3
@export var min_stamina_to_run: float = 25.0

var stamina: float = 100.0:
	set(value):
		var new_value: float = clampf(value, 0.0, max_stamina)
		if new_value == stamina:
			return
		stamina = new_value
		stamina_changed.emit(stamina, max_stamina)

func _ready() -> void:
	stamina = max_stamina
	var states: Array[State] = [PlayerIdleState.new(self), PlayerWalkingState.new(self), PlayerJumpState.new(self), PlayerCrouchIdleState.new(self), PlayerCrouchWalkState.new(self), PlayerRunningState.new(self)]
	state_machine.start_machine(states)
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("crouch"):
		is_crouching = !is_crouching

func _physics_process(delta: float) -> void:
	movement_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward").rotated(-camera_controller.global_rotation.y)
	vel_2d = Vector2(velocity.x, velocity.z)

	update_stamina(delta)

	if not is_on_floor():
		var gravity_to_use: float = jump_gravity if velocity.y > 0.0 else fall_gravity
		velocity.y -= gravity_to_use * delta

	move_and_slide()

func can_stand_up() -> bool:
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var shape: CapsuleShape3D = CapsuleShape3D.new()
	shape.radius = 0.4
	shape.height = 1.8

	var query: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
	query.shape = shape
	query.transform = global_transform.translated(Vector3(0, shape.height / 2.0, 0))
	query.exclude = [self]
	query.collision_mask = collision_mask

	var result := space_state.intersect_shape(query, 1)
	return result.is_empty()

func drain_stamina(amount: float) -> void:
	stamina -= amount

func update_stamina(delta: float) -> void:
	if state_machine.current_state is PlayerRunningState:
		return

	var regen: float = regen_standing_per_second if movement_input == Vector2.ZERO else regen_walking_per_second
	stamina += regen * delta