extends Node

# default save values
var og_save = {
	"flashingLights": true,
	"cameraZooms": true,
	"downscroll": false,
	"opponent_note_glow": true,
	"volume": 0,
	"muted": false,
	"binds_4": ["D", "F", "J", "K"],
	"binds_5": ["D", "F", "SPACE", "J", "K"],
	"binds_6": ["S", "D", "F", "J", "K", "L"],
	"binds_7": ["S", "D", "F", "SPACE", "J", "K", "L"],
	"binds_8": ["A", "S", "D", "F", "H", "J", "K", "L"],
	"binds_9": ["A", "S", "D", "F", "SPACE", "H", "J", "K", "L"],
	"binds_10": ["A", "S", "D", "F", "G", "H", "J", "K", "L", "SEMICOLON"],
	"bot": false,
	"offset": 0,
	"middlescroll": false,
	"active_mods": [],
	"vsync": false,
	"debug_menus": true,
	"new_sustain_animations": true,
	"memory_leaks": false,
	"miss_sounds": true,
	"charter_hitsounds": false,
	"ultra_performance": false,
	"scene_transitions": true,
	"hitsounds": false,
	"hitsound": "osu mania",
	"freeplay_cutscenes": false,
	"health_icon_bounce": "default",
	"etterna_mode": false,
	"custom_scroll_bool": false,
	"custom_scroll": 1.0,
	"story_mode_icons": true,
	"note_render_style": "default",
	"song_scores": {},
	"week_scores": {}
}

var save = {}

var save_file = File.new()

func _ready():
	if save_file.file_exists("user://Settings.json"):
		save_file.open("user://Settings.json", File.READ)
		save = JSON.parse(save_file.get_as_text()).result
	else:
		save_file.open("user://Settings.json", File.WRITE)
		save_file.store_line(to_json(og_save))
	
	for thing in og_save:
		if not thing in save:
			save[thing] = og_save[thing]
	
	save_file.close()
	
	OS.set_use_vsync(save["vsync"])
	
	setup_binds()

func save_dict():
	return save

func get_data(data):
	return save[data]

func set_data(data, value):
	save[data] = value
	
	save_file.open("user://Settings.json", File.WRITE)
	save_file.store_line(to_json(save))
	
	save_file.close()

func setup_binds():
	Input.set_use_accumulated_input(false)
	
	var binds = get_data("binds_" + str(Globals.key_count))
	
	for action_num in Globals.key_count:
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
