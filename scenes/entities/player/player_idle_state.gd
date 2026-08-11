class_name PlayerIdleState extends PlayerState

static var state_name = "PlayerIdleState"
var stop_force: float = 3.0

func get_state_name() -> String:
    return state_name

func process(_delta: float) -> void:
    if Input.is_action_just_pressed("jump"):
        state_machine.transition(PlayerJumpState.state_name)
        return
    animation_player.play("player/idle")

func physics_process(delta: float) -> void:
    if player.movement_input != Vector2.ZERO:
        state_machine.transition(PlayerWalkingState.state_name)
        return
    elif player.movement_input == Vector2.ZERO:
        player.vel_2d = player.vel_2d.move_toward(Vector2.ZERO, PlayerWalkingState.walking_speed * stop_force * delta)
        player.velocity.x = player.vel_2d.x
        player.velocity.z = player.vel_2d.y