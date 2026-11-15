class_name PlayerCrouchIdleState extends PlayerState

static var state_name = "PlayerCrouchIdleState"
var stop_force: float = 3.0

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
	animation_player.play("player/crouch_idle")

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

	if player.movement_input != Vector2.ZERO:
		state_machine.transition(PlayerCrouchWalkState.state_name)
		return

	player.brake(PlayerWalkingState.walking_speed * stop_force, delta)