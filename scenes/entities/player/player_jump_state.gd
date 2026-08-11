class_name PlayerJumpState extends PlayerState

static var state_name = "PlayerJumpState"

const TAKEOFF_DELAY: float = 0.5

var is_jumping: bool
var has_launched: bool

func get_state_name() -> String:
	return state_name

func enter() -> void:
	is_jumping = false
	has_launched = false

	if player.movement_input != Vector2.ZERO:
		animation_player.play("player/jump_running")
		launch()
	else:
		animation_player.play("player/jump")
		delayed_launch()

func process(_delta: float) -> void:
	if has_launched and not player.is_on_floor():
		is_jumping = true

func physics_process(_delta) -> void:
	if is_jumping and player.is_on_floor() and player.velocity.y <= 0.0:
		if player.movement_input != Vector2.ZERO:
			state_machine.transition(PlayerWalkingState.state_name)
		else:
			state_machine.transition(PlayerIdleState.state_name)

func launch() -> void:
	player.velocity.y = -(player.jump_velocity)
	has_launched = true

func delayed_launch() -> void:
	await player.get_tree().create_timer(TAKEOFF_DELAY).timeout
	if state_machine.current_state != self:
		return 
	launch()