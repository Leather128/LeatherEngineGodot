extends Node

var current_scene:String = ""

var switching:bool = false

func switch_scene(scenePath):
	if !switching:
		switching = true
		
		current_scene = scenePath
		
		GameplaySettings.do_cutscenes = true
		
		if Settings.get_data("scene_transitions"):
			Transition.trans_in()
			
			var t = Timer.new()
			t.set_wait_time(0.5)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()
		
		var success = get_tree().change_scene(Paths.scene_path(scenePath))
		
		if Settings.get_data("scene_transitions"):
			Transition.trans_out()
		
		switching = false
		
		if OS.is_debug_build():
			if success != 0:
				print("Menu Loaded Inproperly! Code: " + str(success))
