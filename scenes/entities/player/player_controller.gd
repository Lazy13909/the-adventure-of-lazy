class_name PlayerController extends CharacterBody3D

@onready var animation_player = $Erika/AnimationPlayer
@onready var state_machine = $StateMachine
@onready var skin = $Erika

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

func _ready() -> void:
	var states: Array[State] = [PlayerIdleState.new(self), PlayerWalkingState.new(self), PlayerJumpState.new(self), PlayerCrouchIdleState.new(self), PlayerCrouchWalkState.new(self)]
	state_machine.start_machine(states)

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("crouch"):
		is_crouching = !is_crouching

func _physics_process(_delta: float) -> void:
	movement_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward").rotated(-camera_controller.global_rotation.y)
	vel_2d = Vector2(velocity.x, velocity.z)
	
	if not is_on_floor():
		var gravity_to_use: float = jump_gravity if velocity.y > 0.0 else fall_gravity
		velocity.y -= gravity_to_use * _delta

	move_and_slide()
