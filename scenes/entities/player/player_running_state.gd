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
	
	player.vel_2d += player.movement_input * running_speed * delta
	player.vel_2d = player.vel_2d.limit_length(running_speed)
	player.velocity.x = player.vel_2d.x
	player.velocity.z = player.vel_2d.y

	var target_angle: float = -(player.movement_input.angle() + PI / 2)
	player.skin.rotation.y = rotate_toward(player.skin.rotation.y, target_angle, 6.0 * delta)