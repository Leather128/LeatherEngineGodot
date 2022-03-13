extends Node

var current_scene:String = ""

func switch_scene(scenePath):
	current_scene = scenePath
	
	var success = get_tree().change_scene(Paths.scene_path(scenePath))
	
	if OS.is_debug_build():
		if success != 0:
			print("Menu Loaded Inproperly! Code: " + str(success))
