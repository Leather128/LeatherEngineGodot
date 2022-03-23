extends Node

func _ready():
	setup_Binds()

func setup_Binds():
	var binds = Settings.get_data("binds_" + str(GameplaySettings.key_count))
	
	for action_num in GameplaySettings.key_count:
		var action = "gameplay_" + str(action_num)
		
		var keys = InputMap.get_action_list(action)
		
		var new_Event = InputEventKey.new()
		# set key to the scancode of the key
		new_Event.set_scancode(OS.find_scancode_from_string(binds[action_num].to_lower()))
		
		if keys.size() - 1 != -1: # error handling shit i forgot the cause of lmao
			InputMap.action_erase_event(action, keys[keys.size()-1])
		else:
			InputMap.add_action(action)
		
		InputMap.action_add_event(action, new_Event)
