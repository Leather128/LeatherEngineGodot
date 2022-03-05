extends Node

var og_save = {
	"flashingLights": true,
	"cameraZooms": true,
	"downscroll": false,
	"opponent_note_glow": true,
	"volume": 0,
	"muted": false,
	"binds_4": ["A", "S", "W", "D"],
	"binds_6": ["S", "D", "F", "J", "K", "L"],
	"binds_9": ["A", "S", "D", "F", "SPACE", "H", "J", "K", "L"],
	"bot": false,
	"offset": 0,
	"middlescroll": false,
	"active_mods": [],
	"vsync": false
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
