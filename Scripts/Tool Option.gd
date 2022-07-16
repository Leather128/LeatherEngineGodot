extends Node2D

export(String) var scene = "Charter"

export(String) var description = ""

var is_bool = false

func open_option():
	AudioHandler.stop_audio("Tools Menu")
	AudioHandler.play_audio("Confirm Sound")
	AudioHandler.stop_audio("Title Music")
	
	if scene == "Charter":
		Globals.songName = "test"
		Globals.songDifficulty = "normal"
		Globals.freeplay = true
		
		var file = File.new()
		file.open(Paths.song_path(Globals.songName, Globals.songDifficulty), File.READ)
		
		Globals.song = JSON.parse(file.get_as_text()).result["song"]
		
		if not "ui_skin" in Globals.song:
			Globals.song["ui_skin"] = "default"
		
		if not "gf" in Globals.song:
			Globals.song["gf"] = "gf"
		
		if not "stage" in Globals.song:
			Globals.song["stage"] = "stage"
		
		var inst = AudioHandler.get_node("Inst")
		
		inst.stream = null
	
		var song_path = "res://Assets/Songs/" + Globals.songName.to_lower() + "/"
		
		if File.new().file_exists(song_path + "Inst-" + Globals.songDifficulty.to_lower() + ".ogg"):
			inst.stream = load(song_path + "Inst-" + Globals.songDifficulty.to_lower() + ".ogg")
		else:
			inst.stream = load(song_path + "Inst.ogg")
		
		inst.pitch_scale = Globals.song_multiplier
		inst.volume_db = 0
		
		if Globals.song["needsVoices"]:
			var voices = AudioHandler.get_node("Voices")
			
			voices.stream = null
			
			if File.new().file_exists(song_path + "Voices-" + Globals.songDifficulty.to_lower() + ".ogg"):
				voices.stream = load(song_path + "Voices-" + Globals.songDifficulty.to_lower() + ".ogg")
			else:
				voices.stream = load(song_path + "Voices.ogg")
			
			voices.pitch_scale = Globals.song_multiplier
			voices.volume_db = 0
	
	Scenes.switch_scene(scene)
