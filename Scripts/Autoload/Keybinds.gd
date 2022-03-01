extends Node

var actions = [
	"gameplay_left",
	"gameplay_down",
	"gameplay_up",
	"gameplay_right"
]

func _ready():
	setup_Binds()

func setup_Binds():
	var binds = Settings.get_data("binds")
	
	for action in actions:
		var keys = InputMap.get_action_list(action)
		
		var new_Event = InputEventKey.new()
		new_Event.set_scancode(OS.find_scancode_from_string(binds[actions.find(action)].to_lower()))
		
		InputMap.action_erase_event(action, keys[keys.size()-1])
		InputMap.action_add_event(action, new_Event)
