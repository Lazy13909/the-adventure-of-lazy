class_name PlayerRunningState extends PlayerState

static var state_name = "PlayerRunningState"
static var running_speed: float = 4.5

func get_state_name() -> String:
	return state_name

func process(_delta: float) -> void:
	animation_player.play("player/running")

func physics_process(delta: float) -> void:
	if player.is_crouching:
		state_machine.transition(PlayerCrouchWalkState.state_name)
		return

	if player.movement_input == Vector2.ZERO:
		state_machine.transition(PlayerIdleState.state_name)
		return

	if not Input.is_action_pressed("run"):
		state_machine.transition(PlayerWalkingState.state_name)
		return

	if player.stamina <= 0.0:
		state_machine.transition(PlayerWalkingState.state_name)
		return

	player.drain_stamina(player.run_drain_per_second * delta)
	player.accelerate(running_speed, delta)
	player.rotate_skin_toward_input(delta)
