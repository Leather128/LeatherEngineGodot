extends Node

func play_audio(audioName, startTime = 0.0):
	if get_node(audioName) != null:
		get_node(audioName).play(startTime)

func stop_audio(audioName):
	if get_node(audioName) != null:
		get_node(audioName).stop()
