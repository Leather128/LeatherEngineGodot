extends Node

var current_scene:String = ""

func switch_scene(scenePath):
	current_scene = scenePath
	
	GameplaySettings.do_cutscenes = true
	
	Transition.trans_in()
	
	var t = Timer.new()
	t.set_wait_time(0.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	var success = get_tree().change_scene(Paths.scene_path(scenePath))
	
	Transition.trans_out()
	
	if OS.is_debug_build():
		if success != 0:
			print("Menu Loaded Inproperly! Code: " + str(success))
