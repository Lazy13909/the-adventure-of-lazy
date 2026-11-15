class_name PlayerWalkingState extends PlayerState

static var state_name = "PlayerWalkingState"
static var walking_speed: float = 2.5

func get_state_name() -> String:
	return state_name

func process(_delta: float) -> void:
	if player.wants_to_jump():
		state_machine.transition(PlayerJumpState.state_name)
		return
	animation_player.play("player/walking")

func physics_process(delta: float) -> void:
	if player.is_crouching:
		state_machine.transition(PlayerCrouchWalkState.state_name)
		return

	if Input.is_action_pressed("run") and player.movement_input != Vector2.ZERO and player.stamina >= player.min_stamina_to_run:
		state_machine.transition(PlayerRunningState.state_name)
		return

	if player.movement_input == Vector2.ZERO:
		state_machine.transition(PlayerIdleState.state_name)
		return

	player.accelerate(walking_speed, delta)
	player.rotate_skin_toward_input(delta)