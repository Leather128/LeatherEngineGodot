extends Node2D

export(String) var scene = "Charter"

export(String) var description = ""

var is_bool = false

func open_option():
	AudioHandler.stop_audio("Tools Menu")
	AudioHandler.play_audio("Confirm Sound")
	AudioHandler.stop_audio("Title Music")
	
	if scene == "Charter":
		GameplaySettings.songName = "test"
		GameplaySettings.songDifficulty = "normal"
		GameplaySettings.freeplay = true
		
		var file = File.new()
		file.open(Paths.song_path(GameplaySettings.songName, GameplaySettings.songDifficulty), File.READ)
		
		GameplaySettings.song = JSON.parse(file.get_as_text()).result["song"]
		
		if not "ui_skin" in GameplaySettings.song:
			GameplaySettings.song["ui_skin"] = "default"
		
		if not "gf" in GameplaySettings.song:
			GameplaySettings.song["gf"] = "gf"
		
		if not "stage" in GameplaySettings.song:
			GameplaySettings.song["stage"] = "stage"
		
		var inst = AudioHandler.get_node("Inst")
		
		inst.stream = null
	
		var song_path = "res://Assets/Songs/" + GameplaySettings.songName.to_lower() + "/"
		
		if File.new().file_exists(song_path + "Inst-" + GameplaySettings.songDifficulty.to_lower() + ".ogg"):
			inst.stream = load(song_path + "Inst-" + GameplaySettings.songDifficulty.to_lower() + ".ogg")
		else:
			inst.stream = load(song_path + "Inst.ogg")
		
		inst.pitch_scale = GameplaySettings.song_multiplier
		inst.volume_db = 0
		
		if GameplaySettings.song["needsVoices"]:
			var voices = AudioHandler.get_node("Voices")
			
			voices.stream = null
			
			if File.new().file_exists(song_path + "Voices-" + GameplaySettings.songDifficulty.to_lower() + ".ogg"):
				voices.stream = load(song_path + "Voices-" + GameplaySettings.songDifficulty.to_lower() + ".ogg")
			else:
				voices.stream = load(song_path + "Voices.ogg")
			
			voices.pitch_scale = GameplaySettings.song_multiplier
			voices.volume_db = 0
	
	Scenes.switch_scene(scene)
