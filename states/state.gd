class_name State extends Node

func enter():
    pass

func exit():
    pass

func process(_delta: float):
    pass

func physics_process(_delta: float):
    pass

func get_state_name() -> String:
    push_error("Method get_state_name() must be defined.")
    return ""