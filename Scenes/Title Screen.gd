extends Node2D

var started: bool = false

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	
	Discord.update_presence("On the Title Screen")
	
	Conductor.change_bpm(102)
	AudioHandler.play_audio("Title Music")
	
	started = true

func _process(delta):
	if Input.is_action_just_pressed("ui_back"):
		get_tree().quit()
	
	if started:
		Conductor.songPosition += delta * 1000
