extends Node

# GameplaySettings
var songName:String = "tutorial"
var songDifficulty:String = "hard"

var weekSongs:Array = []

var freeplay:bool = false

var scroll_speed:float = 1.0

var key_count:int = 4

var death_character_name:String = "bf-dead"
var death_character_pos:Vector2 = Vector2()
var death_character_cam:Vector2 = Vector2()

var song_multiplier: float = 1.0

var do_cutscenes:bool = true

# song data lmao (used for loading into Gameplay i think)
var song:Dictionary

# NoteFunctions
enum NoteDirection {
	Left,
	Down,
	Up,
	Right,
	Left2,
	Down2,
	Up2,
	Right2,
	Square
	RLeft,
	RUp,
	RDown,
	RRight,
	RLeft2,
	RUp2,
	RDown2,
	RRight2,
	Plus
}

func dir_to_str(cool_dir):
	return NoteDirection.keys()[cool_dir].to_lower()

# bullshit function that is used to make life easier for modders
func dir_to_animstr(dir):
	var str_dir = dir_to_str(dir).to_lower()
	str_dir = str_dir.replace("2", "")
	
	if str_dir.begins_with("r"):
		str_dir = str_dir.right(1)
	
	if str_dir == "ight":
		str_dir = "right"
	
	match(str_dir):
		"plus","square":
			return "up"
		_:
			return str_dir

# NoteGlobals
# hardcoded sprite bullshit because static variables don't exist :(
var held_sprites = {
	"left": [
		load("res://Assets/Images/Notes/default/held/left hold0000.png"),
		load("res://Assets/Images/Notes/default/held/left hold end0000.png")
	],
	"down": [
		load("res://Assets/Images/Notes/default/held/down hold0000.png"),
		load("res://Assets/Images/Notes/default/held/down hold end0000.png")
	],
	"up": [
		load("res://Assets/Images/Notes/default/held/up hold0000.png"),
		load("res://Assets/Images/Notes/default/held/up hold end0000.png")
	],
	"right": [
		load("res://Assets/Images/Notes/default/held/right hold0000.png"),
		load("res://Assets/Images/Notes/default/held/right hold end0000.png")
	],
	"square": [
		load("res://Assets/Images/Notes/default/held/square hold0000.png"),
		load("res://Assets/Images/Notes/default/held/square hold end0000.png")
	],
	"left2": [
		load("res://Assets/Images/Notes/default/held/left2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/left2 hold end0000.png")
	],
	"down2": [
		load("res://Assets/Images/Notes/default/held/down2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/down2 hold end0000.png")
	],
	"up2": [
		load("res://Assets/Images/Notes/default/held/up2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/up2 hold end0000.png")
	],
	"right2": [
		load("res://Assets/Images/Notes/default/held/right2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/right2 hold end0000.png")
	],
	"rleft": [
		load("res://Assets/Images/Notes/default/held/rleft hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rleft hold end0000.png")
	],
	"rdown": [
		load("res://Assets/Images/Notes/default/held/rdown hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rdown hold end0000.png")
	],
	"rup": [
		load("res://Assets/Images/Notes/default/held/rup hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rup hold end0000.png")
	],
	"rright": [
		load("res://Assets/Images/Notes/default/held/rright hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rright hold end0000.png")
	],
	"plus": [
		load("res://Assets/Images/Notes/default/held/plus hold0000.png"),
		load("res://Assets/Images/Notes/default/held/plus hold end0000.png")
	],
	"rleft2": [
		load("res://Assets/Images/Notes/default/held/rleft2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rleft2 hold end0000.png")
	],
	"rdown2": [
		load("res://Assets/Images/Notes/default/held/rdown2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rdown2 hold end0000.png")
	],
	"rup2": [
		load("res://Assets/Images/Notes/default/held/rup2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rup2 hold end0000.png")
	],
	"rright2": [
		load("res://Assets/Images/Notes/default/held/rright2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rright2 hold end0000.png")
	],
}

var loaded: Array = []

func unleak_memory():
	loaded.clear()

func leak_memory():
	print("Well you chose this...")
	print("Say goodbye to your memory.")
	
	leak_some_vram("res://Assets/")
	leak_some_vram("res://Scenes/")
	leak_some_vram("res://Scripts/")
	
	for mod in Settings.get_data("active_mods"):
		ModLoader.load_specific_mod(mod)
		
		leak_some_vram("res://Assets/")
		leak_some_vram("res://Scenes/")
		leak_some_vram("res://Scripts/")
		
	ModLoader._ready()
	
	print(len(loaded))

func leak_some_vram(path):
	for asset_path in get_filelist(path):
		loaded.push_back(load(asset_path))

func get_filelist(scan_dir : String) -> Array:
	var my_files : Array = []
	var dir := Directory.new()
	
	if dir.open(scan_dir) != OK:
		printerr("Warning: could not open directory: ", scan_dir)
		return []

	if dir.list_dir_begin(true, true) != OK:
		printerr("Warning: could not list contents of: ", scan_dir)
		return []

	var file_name := dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			my_files += get_filelist(dir.get_current_dir() + "/" + file_name)
		else:
			my_files.append(dir.get_current_dir() + "/" + file_name)

		file_name = dir.get_next()

	return my_files

# self explanatory
signal player_note_hit(note, dir, type, character)
signal enemy_note_hit(note, dir, type, character)
# must_hit is basically asking if it's a player side note or not btw
signal note_hit(note, dir, type, character, must_hit)

# called when the player misses a note
signal note_miss(note, dir, type, character)

# called every time an event is setup (not sure if this is useful, but better be safe than sorry)
signal event_setup(event)

# called every time an event is triggered
signal event_processed(event)

# formats time into minutes:seconds
func format_time(seconds: float):
	var time_string: String = str(int(seconds / 60)) + ":"
	var time_string_helper: int = int(seconds) % 60
	
	if time_string_helper < 10:
		time_string += "0"
	
	time_string += str(time_string_helper)
	
	return time_string

# lerp value
func lerpv(value_60: float, delta: float):
	return delta * (value_60 / (1.0 / 60.0))

# good lerp
func glerp(value_1, value_2, lerp_value: float, delta: float):
	return lerp(value_1, value_2, lerpv(lerp_value, delta))

func _ready() -> void:
	Discord.init()
	
	if Settings.get_data("memory_leaks"):
		leak_memory()

func _process(_delta):
	if Input.is_action_just_pressed("ui_fullscreen"):
		OS.set_window_fullscreen(!OS.window_fullscreen)
