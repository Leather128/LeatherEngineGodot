extends Node2D

export(String) var scene = "Charter"

func open_option():
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
		
		AudioHandler.get_node("Inst").stream = null
	
		var song_path = "res://Assets/Songs/" + GameplaySettings.songName.to_lower() + "/"
		
		if File.new().file_exists(song_path + "Inst-" + GameplaySettings.songDifficulty.to_lower() + ".ogg"):
			AudioHandler.get_node("Inst").stream = load(song_path + "Inst-" + GameplaySettings.songDifficulty.to_lower() + ".ogg")
		else:
			AudioHandler.get_node("Inst").stream = load(song_path + "Inst.ogg")
		
		AudioHandler.get_node("Inst").pitch_scale = GameplaySettings.song_multiplier
		AudioHandler.get_node("Inst").volume_db = 0
		
		if GameplaySettings.song["needsVoices"]:
			AudioHandler.get_node("Voices").stream = null
			
			if File.new().file_exists(song_path + "Voices-" + GameplaySettings.songDifficulty.to_lower() + ".ogg"):
				AudioHandler.get_node("Voices").stream = load(song_path + "Voices-" + GameplaySettings.songDifficulty.to_lower() + ".ogg")
			else:
				AudioHandler.get_node("Voices").stream = load(song_path + "Voices.ogg")
			
			AudioHandler.get_node("Voices").pitch_scale = GameplaySettings.song_multiplier
			AudioHandler.get_node("Voices").volume_db = 0
	
	Scenes.switch_scene(scene)
