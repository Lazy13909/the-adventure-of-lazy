class_name PlayerCrouchWalkState extends PlayerState

static var state_name = "PlayerCrouchWalkState"
static var crouch_walking_speed: float = 2.0

func get_state_name() -> String:
	return state_name

func enter() -> void:
	player.set_crouch_height(true)

func exit() -> void:
	player.set_crouch_height(false)

func process(_delta: float) -> void:
	if player.wants_to_jump() and player.can_stand_up():
		state_machine.transition(PlayerJumpState.state_name)
		return
	animation_player.play("player/crouch_walking")

func physics_process(delta: float) -> void:
	if not player.is_crouching:
		if not player.can_stand_up():
			player.is_crouching = true
		else:
			if player.movement_input != Vector2.ZERO:
				state_machine.transition(PlayerWalkingState.state_name)
			else:
				state_machine.transition(PlayerIdleState.state_name)
			return

	if player.movement_input == Vector2.ZERO:
		state_machine.transition(PlayerCrouchIdleState.state_name)
		return

	player.accelerate(crouch_walking_speed, delta)
	player.rotate_skin_toward_input(delta)