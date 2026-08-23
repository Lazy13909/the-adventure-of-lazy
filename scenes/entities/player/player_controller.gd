class_name PlayerController extends CharacterBody3D

@onready var animation_player = $Erika/AnimationPlayer
@onready var state_machine = $StateMachine
@onready var skin = $Erika

@onready var camera_controller: Camera3D = $CameraController/Camera3D

@onready var collision_shape: CollisionShape3D = $CollisionShape3D

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

func _ready() -> void:
	var states: Array[State] = [PlayerIdleState.new(self), PlayerWalkingState.new(self), PlayerJumpState.new(self), PlayerCrouchIdleState.new(self), PlayerCrouchWalkState.new(self)]
	state_machine.start_machine(states)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("crouch"):
		is_crouching = !is_crouching

func _physics_process(_delta: float) -> void:
	movement_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward").rotated(-camera_controller.global_rotation.y)
	vel_2d = Vector2(velocity.x, velocity.z)
	
	if not is_on_floor():
		var gravity_to_use: float = jump_gravity if velocity.y > 0.0 else fall_gravity
		velocity.y -= gravity_to_use * _delta

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
	
