extends Node2D

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")

	Conductor.change_bpm(102)
	AudioHandler.play_audio("Title Music")

func _process(delta):
	if Input.is_action_just_pressed("ui_back"):
		get_tree().quit()
	
	Conductor.songPosition += delta * 1000
