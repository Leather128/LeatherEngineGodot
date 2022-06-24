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
	"binds_10": ["Q", "W", "E", "R", "V", "N", "U", "I", "O", "P"],
	"binds_11": ["Q", "W", "E", "R", "V", "SPACE", "N", "U", "I", "O", "P"],
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

func save_dict():
	return save

func get_data(data):
	return save[data]

func set_data(data, value):
	save[data] = value
	
	save_file.open("user://Settings.json", File.WRITE)
	save_file.store_line(to_json(save))
	
	save_file.close()
