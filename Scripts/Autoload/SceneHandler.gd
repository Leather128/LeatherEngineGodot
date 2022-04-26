extends Node

var current_scene:String = ""

var switching:bool = false

var startup:bool = true

func switch_scene(scenePath, no_trans:bool = false):
	if !switching:
		switching = true
		
		GameplaySettings.do_cutscenes = true
		
		if Settings.get_data("scene_transitions") and !no_trans:
			Transition.trans_in()
			
			var t = Timer.new()
			t.set_wait_time(0.5)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()
		
		var success:int
		
		if not scenePath.begins_with("res://"):
			success = get_tree().change_scene(Paths.scene_path(scenePath))
		else:
			success = get_tree().change_scene(scenePath)
		
		if Settings.get_data("scene_transitions") and !no_trans:
			Transition.trans_out()
		
		switching = false
		
		current_scene = scenePath
		
		if OS.is_debug_build():
			if success != 0:
				print("Menu Loaded Inproperly! Code: " + str(success))
