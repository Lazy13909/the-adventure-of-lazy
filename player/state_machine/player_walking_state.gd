class_name PlayerWalkingState extends PlayerState

static var state_name = "PlayerWalkingState"

static var walking_speed: float = 2.5

func get_state_name() -> String:
    return state_name

func process(_delta: float) -> void:
    if Input.is_action_just_pressed("jump"):
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

    if player.movement_input != Vector2.ZERO:
        player.vel_2d += player.movement_input * walking_speed * delta
        player.vel_2d = player.vel_2d.limit_length(walking_speed)
        player.velocity.x = player.vel_2d.x
        player.velocity.z = player.vel_2d.y

        var target_angle: float = -(player.movement_input.angle() + PI/2)
        player.skin.rotation.y = rotate_toward(player.skin.rotation.y, target_angle, 6.0 * delta)
        player.movement_input.normalized()
        
    elif player.movement_input == Vector2.ZERO:
        state_machine.transition(PlayerIdleState.state_name)
        return