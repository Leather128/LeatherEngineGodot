extends "res://Scenes/Cutscenes/Cutscene.gd"

onready var video = $VideoPlayer

func _ready():
	print("STARTING VIDEO")
	
	video.connect("finished", self, "on_finish")
	video.play()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		video.paused = !video.paused
	
	if !video.is_playing():
		on_finish()

func on_finish():
	emit_signal("finished")
	
	print("VIDEO DONE")
	
	queue_free()
