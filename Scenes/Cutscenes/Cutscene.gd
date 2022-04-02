extends Node

signal finished

func _ready():
	Scenes.current_scene = "Cutscene"
	
	if GameplaySettings.song:
		if "song" in GameplaySettings.song:
			Presence.update("In Cutscene", "(" + GameplaySettings.song.song + ")")
