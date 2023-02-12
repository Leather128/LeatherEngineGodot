extends Node

onready var hitsound = $Hitsound

func _ready():
	hitsound.stream = load("res://Assets/Sounds/Hitsounds/" + Settings.get_data("hitsound") + ".ogg")

func play_audio(audioName, startTime = 0.0,speed = 1):
	if get_node(audioName) != null:
		get_node(audioName).pitch_scale = speed
		get_node(audioName).play(startTime)

func stop_audio(audioName):
	if get_node(audioName) != null:
		get_node(audioName).stop()
		
func get_audio_playback(audioName):
	if get_node(audioName) != null:
		return get_node(audioName).get_playback_position()
