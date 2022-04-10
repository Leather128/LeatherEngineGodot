extends Node

var loaded: Array = []

func _ready():
	if Settings.get_data("memory_leaks"):
		leak_memory()

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
