# player_crouch_walk_state.gd
class_name PlayerCrouchWalkState
extends PlayerState

static var state_name = "PlayerCrouchWalkState"
static var crouch_walking_speed: float = 2.0

func get_state_name() -> String:
	return state_name

func process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		state_machine.transition(PlayerJumpState.state_name)
		return
	animation_player.play("player/crouch_walking")

func physics_process(delta: float) -> void:
	if not player.is_crouching:
		if player.movement_input != Vector2.ZERO:
			state_machine.transition(PlayerWalkingState.state_name)
		else:
			state_machine.transition(PlayerIdleState.state_name)
		return

	if player.movement_input == Vector2.ZERO:
		state_machine.transition(PlayerCrouchIdleState.state_name)
		return

	player.vel_2d += player.movement_input * crouch_walking_speed * delta
	player.vel_2d = player.vel_2d.limit_length(crouch_walking_speed)
	player.velocity.x = player.vel_2d.x
	player.velocity.z = player.vel_2d.y

	var target_angle: float = -(player.movement_input.angle() + PI / 2)
	player.skin.rotation.y = rotate_toward(player.skin.rotation.y, target_angle, 6.0 * delta)