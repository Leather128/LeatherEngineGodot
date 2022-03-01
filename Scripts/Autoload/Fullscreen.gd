extends Node

func _process(_delta):
	if Input.is_action_just_pressed("ui_fullscreen"):
		OS.set_window_fullscreen(!OS.window_fullscreen)
