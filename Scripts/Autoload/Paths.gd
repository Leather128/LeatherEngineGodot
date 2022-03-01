extends Node

func scene_path(path):
	return "res://Scenes/" + path + ".tscn"

func stage_path(stage):
	return "res://Scenes/Stages/" + stage + ".tscn"

func song_path(song, difficulty):
	return "res://Assets/Songs/" + song.to_lower() + "/" + difficulty.to_lower() + ".json"

func char_path(character):
	return "res://Scenes/Characters/" + character.to_lower() + ".tscn"
