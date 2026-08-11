class_name PlayerState extends State

var player: PlayerController
var animation_player: AnimationPlayer
var state_machine: StateMachine

func _init(player_controller: PlayerController) -> void:
    player = player_controller
    animation_player = player.animation_player
    state_machine = player.state_machine