class_name PlayerCrouchIdleState extends PlayerState

static var state_name = "PlayerCrouchIdleState"
var stop_force: float = 3.0

func get_state_name() -> String:
	return state_name

func enter() -> void:
	set_crouch_height(true)

func exit() -> void:
	set_crouch_height(false)
	
func process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and player.can_stand_up():
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
			elif player.movement_input == Vector2.ZERO:
				state_machine.transition(PlayerIdleState.state_name)
			return

	if player.movement_input != Vector2.ZERO:
		state_machine.transition(PlayerCrouchWalkState.state_name)
		return

	player.vel_2d = player.vel_2d.move_toward(Vector2.ZERO, PlayerWalkingState.walking_speed * stop_force * delta)
	player.velocity.x = player.vel_2d.x
	player.velocity.z = player.vel_2d.y

func set_crouch_height(crouching: bool) -> void:
	var shape: CapsuleShape3D = player.collision_shape.shape
	var target_height: float = player.CROUCH_HEIGHT if crouching else player.STANDING_HEIGHT
	shape.height = target_height

	player.collision_shape.position.y = target_height / 2 