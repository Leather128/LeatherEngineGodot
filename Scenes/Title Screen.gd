extends Node2D

func _ready():
	var t = Timer.new()
	t.set_wait_time(0.1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()

	Conductor.change_bpm(102)
	AudioHandler.play_audio("Title Music")
	
	Presence.update("Title Screen")

func _process(delta):
	if Input.is_action_just_pressed("ui_back"):
		get_tree().quit()
	
	Conductor.songPosition += delta * 1000
