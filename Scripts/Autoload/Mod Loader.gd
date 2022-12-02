extends Node

# list of mods that can be enabled
var mods = []

var mod_dir = "user://Mods/"

var dir = Directory.new()

# funny Mod.tscn data, but into a dictionary
var mod_instances = {}

func _ready():
	load_mods()
	
func detect_mods():
	mods = []
	
	dir.make_dir_recursive(mod_dir)
	dir.open(mod_dir)
	
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		
		if file == "":
			break
		elif !file.begins_with(".") and file.ends_with(".pck"):
			# puts the file name (minus the last 4 characters (aka file extension)) into mods that can be enabled
			mods.append(file.left(len(file) - 4))

func load_mods():
	mod_instances = {}
	
	detect_mods()
	
	# tries to reload base game pack (only works in export builds D:)
	ProjectSettings.load_resource_pack("Leather Engine.pck", true)
	
	for mod in Settings.get_data("active_mods"):
		if mods.has(mod): # WE GOT A MATCH!!!
			var success = ProjectSettings.load_resource_pack(mod_dir + mod + ".pck")
			
			if !success:
				print("Mod load failed :(")
			else:
				var f = File.new()
				
				if f.file_exists("res://Scenes/Mods/" + mod + ".tscn"):
					var mod_data = load("res://Scenes/Mods/" + mod + ".tscn").instance()
					mod_instances[mod] = mod_data
				else:
					if f.file_exists("res://Scenes/Mods/Mod.tscn"):
						var mod_data = load("res://Scenes/Mods/Mod.tscn").instance()
						mod_instances[mod] = mod_data
					else:
						print("Mod didn't have any mod data!\nTry a different file name maybe?")
	
	Settings._ready()

func load_specific_mod(mod):
	ProjectSettings.load_resource_pack("Leather Engine.pck", true)
	
	if mod != null:
		if Settings.get_data("active_mods").has(mod):
			var success = ProjectSettings.load_resource_pack(mod_dir + mod + ".pck")
			
			if !success:
				print("Mod load failed :(")
			else:
				var f = File.new()
				
				if f.file_exists("res://Scenes/Mods/" + mod + ".tscn"):
					var mod_data = load("res://Scenes/Mods/" + mod + ".tscn").instance()
					mod_instances[mod] = mod_data
				else:
					if f.file_exists("res://Scenes/Mods/Mod.tscn"):
						var mod_data = load("res://Scenes/Mods/Mod.tscn").instance()
						mod_instances[mod] = mod_data
					else:
						print("Mod didn't have any mod data!\nTry a different file name maybe?")
	
	Settings._ready()
