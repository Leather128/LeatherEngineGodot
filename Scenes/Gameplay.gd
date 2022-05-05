extends Node2D

var template_note:Node2D

var template_notes:Dictionary = {}

var stageString:String = "stage"
var defaultCameraZoom:float

var songData:Dictionary = {}

var bf:Node2D
var dad:Node2D
var gf:Node2D

var stage:Node2D

var strums:PackedScene

var gameplay_text:RichTextLabel

var enemy_notes:Node2D
var player_notes:Node2D

var noteDataArray = []

var misses:int = 0
var combo:int = 0
var score:int = 0

var accuracy:float = 0.0

var key_count:int = 4

var health:float = 1.0

onready var health_bar = $"UI/Health Bar"

var player_icon:Sprite
var enemy_icon:Sprite

var counter = -1
var counting = false
var in_cutscene = false

onready var countdown_node = $"UI/Countdown"

var bpm_changes = []

var strum_texture:SpriteFrames

var ratings = {
	"marvelous": 0,
	"sick": 0,
	"good": 0,
	"bad": 0,
	"shit": 0
}

var ms_offsync_allowed: float = 20

var player_strums: Node2D
var enemy_strums: Node2D

onready var progress_bar = $"UI/Progress Bar"

func section_start_time(section = 0):
	var coolPos:float = 0.0
	
	var good_bpm = songData["bpm"]
	
	for i in section:
		if "changeBPM" in songData.notes[i]:
			if songData.notes[i]["changeBPM"] == true:
				good_bpm = songData.notes[i]["bpm"]
		
		coolPos += 4 * (1000 * (60 / good_bpm))
	
	return coolPos

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	if OS.get_name().to_lower() == "windows":
		ms_offsync_allowed = 30 # because for some reason windows has weird syncing issues that i'm too stupid to fix properly
	
	ms_offsync_allowed *= GameplaySettings.song_multiplier
	
	Conductor.safeZoneOffset = 166 * GameplaySettings.song_multiplier
	
	songData = GameplaySettings.song
	
	bpm_changes = Conductor.map_bpm_changes(songData)
	
	if "keyCount" in songData:
		key_count = int(songData["keyCount"])
	elif "mania" in songData:
		match(int(songData["mania"])):
			1:
				key_count = 6
			2:
				key_count = 7
			3:
				key_count = 9
			_:
				key_count = 4
	
	songData["keyCount"] = key_count
	GameplaySettings.song["keyCount"] = key_count
	
	GameplaySettings.key_count = key_count
	Keybinds.setup_Binds()
	
	strum_texture = load("res://Assets/Images/Notes/default/default.res")
	template_notes["default"] = load("res://Scenes/Gameplay/Note.tscn").instance()
	
	strums = load("res://Scenes/Gameplay/Strums/" + str(key_count) + ".tscn")
	
	if strums == null:
		key_count = 4
		GameplaySettings.key_count = key_count
		Keybinds.setup_Binds()
		
		strums = load("res://Scenes/Gameplay/Strums/" + str(key_count) + ".tscn")
	
	AudioHandler.stop_audio("Title Music")
	
	if "stage" in songData:
		stageString = songData.stage
	else:
		match(GameplaySettings.songName.to_lower()):
			"spookeez","south","monster":
				stageString = "spooky"
	
	if "ui_Skin" in songData:
		songData["ui_skin"] = songData["ui_Skin"]
	
	if not "ui_skin" in songData:
		songData["ui_skin"] = "default"
	
	var skin_data:Node2D
	
	if "ui_skin" in songData:
		var skin = songData["ui_skin"]
		
		skin_data = load("res://Scenes/UI Skins/" + skin + ".tscn").instance()
		
		if skin_data == null:
			skin_data = load("res://Scenes/UI Skins/default.tscn").instance()
		
		rating_textures = [
			load(skin_data.rating_path + "marvelous.png"),
			load(skin_data.rating_path + "sick.png"),
			load(skin_data.rating_path + "good.png"),
			load(skin_data.rating_path + "bad.png"),
			load(skin_data.rating_path + "shit.png")
		]
		
		numbers = [
			load(skin_data.numbers_path + "num0.png"),
			load(skin_data.numbers_path + "num1.png"),
			load(skin_data.numbers_path + "num2.png"),
			load(skin_data.numbers_path + "num3.png"),
			load(skin_data.numbers_path + "num4.png"),
			load(skin_data.numbers_path + "num5.png"),
			load(skin_data.numbers_path + "num6.png"),
			load(skin_data.numbers_path + "num7.png"),
			load(skin_data.numbers_path + "num8.png"),
			load(skin_data.numbers_path + "num9.png")
		]
		
		health_bar.get_node("Bar/Sprite").texture = skin_data.health_bar_texture
		
		template_notes["default"].get_node("AnimatedSprite").frames = skin_data.notes_texture
		
		if "note_scale" in skin_data:
			template_notes["default"].scale *= Vector2(skin_data.note_scale, skin_data.note_scale)
		
		if "note_hold_scale" in skin_data:
			template_notes["default"].get_node("Line2D").scale = skin_data.note_hold_scale
		
		var ready = countdown_node.get_node("Ready")
		var set = countdown_node.get_node("Set")
		var go = countdown_node.get_node("Go")
		
		if "countdown_scale" in skin_data:
			ready.scale = Vector2(skin_data.countdown_scale, skin_data.countdown_scale)
			set.scale = Vector2(skin_data.countdown_scale, skin_data.countdown_scale)
			go.scale = Vector2(skin_data.countdown_scale, skin_data.countdown_scale)
		
		ready.texture = skin_data.ready_texture
		set.texture = skin_data.set_texture
		go.texture = skin_data.go_texture
		
		if "rating_scale" in skin_data:
			var ratings_thing = get_node("UI/Ratings")
			
			var rating = ratings_thing.get_node("Rating")
			rating.scale = Vector2(skin_data.rating_scale, skin_data.rating_scale)
		
		if "number_scale" in skin_data:
			var ratings_thing = get_node("UI/Ratings")
			
			for child in ratings_thing.get_node("Numbers").get_children():
				child.scale = Vector2(skin_data.number_scale, skin_data.number_scale)
		
		for texture in NoteGlobals.held_sprites:
			NoteGlobals.held_sprites[texture][0] = load(skin_data.held_note_path + texture + " hold0000.png")
			NoteGlobals.held_sprites[texture][1] = load(skin_data.held_note_path + texture + " hold end0000.png")
		
		strum_texture = skin_data.strums_texture
	
	var gfName:String = "gf"
	
	if "gf" in songData:
		gfName = songData["gf"]
	elif "gfVersion" in songData:
		gfName = songData["gfVersion"]
	elif "player3" in songData:
		gfName = songData["player3"]
	
	songData["gf"] = gfName

	if !Settings.get_data("ultra_performance"):
		var stageObj = load(Paths.stage_path(stageString))
		
		if stageObj == null:
			stageObj = load(Paths.stage_path("stage"))
		
		stage = stageObj.instance()
		add_child(stage)
	else:
		var stageObj = load(Paths.stage_path(""))
		
		stage = stageObj.instance()
		add_child(stage)
	
	var zoomThing = 1 - stage.camZoom
	var goodZoom = 1 + zoomThing
	
	$Camera2D.zoom = Vector2(goodZoom, goodZoom)
	defaultCameraZoom = goodZoom
	
	if !Settings.get_data("ultra_performance"):
		var gfLoaded = load(Paths.char_path(gfName))
		
		if gfLoaded == null:
			gfLoaded = load(Paths.char_path("gf"))
		
		gf = gfLoaded.instance()
		gf.position = stage.get_node("GF Point").position
		add_child(gf)

		var bfLoaded = load(Paths.char_path(songData["player1"]))
		
		if bfLoaded == null:
			bfLoaded = load(Paths.char_path("bf"))
		
		bf = bfLoaded.instance()
		bf.position = stage.get_node("Player Point").position
		bf.scale.x *= -1
		add_child(bf)
		
		var dadLoaded = load(Paths.char_path(songData["player2"]))
		
		if dadLoaded == null:
			dadLoaded = load(Paths.char_path("bf"))
		
		dad = dadLoaded.instance()
		dad.position = stage.get_node("Dad Point").position
		add_child(dad)
	
	if !Settings.get_data("ultra_performance"):
		if songData["player2"] == "":
			dad.queue_free()
			dad = gf
	
	if !Settings.get_data("ultra_performance"):
		health_bar.get_node("Bar/ProgressBar").get("custom_styles/fg").bg_color = bf.health_bar_color
		health_bar.get_node("Bar/ProgressBar").get("custom_styles/bg").bg_color = dad.health_bar_color
	
	player_icon = health_bar.get_node("Player")
	enemy_icon = health_bar.get_node("Opponent")
	
	if !Settings.get_data("ultra_performance"):
		player_icon.texture = bf.health_icon
		
		if player_icon.texture.get_width() <= 300:
			player_icon.hframes = 2
		if player_icon.texture.get_width() <= 150:
			player_icon.hframes = 1
		
		enemy_icon.texture = dad.health_icon
		
		if enemy_icon.texture.get_width() <= 300:
			enemy_icon.hframes = 2
		if enemy_icon.texture.get_width() <= 150:
			enemy_icon.hframes = 1
	
	if !Settings.get_data("ultra_performance"):
		$Camera2D.position = stage.get_node("Player Point").position + Vector2(-1 * bf.camOffset.x, bf.camOffset.y)
	
	for section in songData["notes"]:
		for note in section["sectionNotes"]:
			if note[1] != -1:
				if len(note) == 3:
					note.push_back(0)
				
				var type:String = "default"
				
				if note[3] is Array:
					note[3] = note[3][0]
				elif note[3] is String:
					type = note[3]
					
					note[3] = 0
					note.push_back(type)
				
				if len(note) == 4:
					note.push_back("default")
				
				if note[4]:
					if note[4] is String:
						type = note[4]
						
						if not type in template_notes:
							var loaded_note = load("res://Scenes/Gameplay/Note Types/" + type + ".tscn")
							
							if loaded_note != null:
								template_notes[type] = loaded_note.instance()
							else:
								template_notes[type] = template_notes["default"]
				
				if not "altAnim" in section:
					section["altAnim"] = false
				
				noteDataArray.push_back([float(note[0]) + Settings.get_data("offset") + (AudioServer.get_output_latency() * 1000), note[1], note[2], bool(section["mustHitSection"]), int(note[3]), type, bool(section["altAnim"])])
	
	noteDataArray.sort_custom(self, "note_sort")
	
	AudioHandler.get_node("Inst").stream = null
	
	var song_path = "res://Assets/Songs/" + GameplaySettings.songName.to_lower() + "/"
	
	if File.new().file_exists(song_path + "Inst-" + GameplaySettings.songDifficulty.to_lower() + ".ogg"):
		AudioHandler.get_node("Inst").stream = load(song_path + "Inst-" + GameplaySettings.songDifficulty.to_lower() + ".ogg")
	else:
		AudioHandler.get_node("Inst").stream = load(song_path + "Inst.ogg")
	
	AudioHandler.get_node("Inst").pitch_scale = GameplaySettings.song_multiplier
	AudioHandler.get_node("Inst").volume_db = 0
	
	if songData["needsVoices"]:
		AudioHandler.get_node("Voices").stream = null
		
		if File.new().file_exists(song_path + "Voices-" + GameplaySettings.songDifficulty.to_lower() + ".ogg"):
			AudioHandler.get_node("Voices").stream = load(song_path + "Voices-" + GameplaySettings.songDifficulty.to_lower() + ".ogg")
		else:
			AudioHandler.get_node("Voices").stream = load(song_path + "Voices.ogg")
		
		AudioHandler.get_node("Voices").pitch_scale = GameplaySettings.song_multiplier
		AudioHandler.get_node("Voices").volume_db = 0
	
	GameplaySettings.scroll_speed = float(songData["speed"])
	
	GameplaySettings.scroll_speed /= GameplaySettings.song_multiplier
	
	if GameplaySettings.scroll_speed <= 0:
		GameplaySettings.scroll_speed = 0.1
	
	Conductor.songPosition = 0
	Conductor.curBeat = 0
	Conductor.curStep = 0
	Conductor.change_bpm(float(songData["bpm"]), bpm_changes)
	Conductor.connect("beat_hit", self, "beat_hit")
	
	var uiNode = $UI
	
	gameplay_text = uiNode.get_node("Gameplay Text/Gameplay Text")
	
	player_notes = uiNode.get_node("Player Notes")
	enemy_notes = uiNode.get_node("Enemy Notes")
	
	player_strums = strums.instance()
	player_strums.name = "Player Strums"
	player_strums.is_player = true
	player_strums.position.x = 800
	
	enemy_strums = strums.instance()
	enemy_strums.name = "Enemy Strums"
	enemy_strums.is_player = false
	enemy_strums.position.x = 150
	
	for strum in player_strums.get_children():
		strum.get_node("AnimatedSprite").frames = strum_texture
		
		if skin_data:
			if "strum_scale" in skin_data:
				strum.scale *= Vector2(skin_data.strum_scale, skin_data.strum_scale)
	
	for strum in enemy_strums.get_children():
		strum.get_node("AnimatedSprite").frames = strum_texture
		strum.enemy_strum = true
		
		if skin_data:
			if "strum_scale" in skin_data:
				strum.scale *= Vector2(skin_data.strum_scale, skin_data.strum_scale)
	
	uiNode.add_child(player_strums)
	uiNode.add_child(enemy_strums)
	
	if Settings.get_data("downscroll"):
		player_strums.position.y = 640
		enemy_strums.position.y = 640
		gameplay_text.rect_position.y = 115
		health_bar.position.y = 56
		progress_bar.position.y = 698
	else:
		player_strums.position.y = 90
		enemy_strums.position.y = 90
		gameplay_text.rect_position.y = 682
		health_bar.position.y = 623
		progress_bar.position.y = 6
	
	if Settings.get_data("middlescroll"):
		player_strums.position.x = 470
		$"UI/Ratings".position.x = 253
		
		enemy_strums.visible = false
		enemy_notes.visible = false
	
	player_notes.position.x = player_strums.position.x
	enemy_notes.position.x = enemy_strums.position.x
	
	player_notes.scale = player_strums.scale
	enemy_notes.scale = enemy_strums.scale
	
	Conductor.songPosition = (Conductor.timeBetweenBeats * -4) * GameplaySettings.song_multiplier
	
	update_gameplay_text()
	
	var freeplay_song_data = false
	
	if "cutscene_in_freeplay" in songData:
		freeplay_song_data = songData.cutscene_in_freeplay
	
	if Settings.get_data("freeplay_cutscenes"):
		freeplay_song_data = true
	
	if (!GameplaySettings.freeplay or freeplay_song_data) and GameplaySettings.do_cutscenes:
		if "cutscene" in songData:
			if File.new().file_exists("res://Scenes/Cutscenes/" + songData["cutscene"] + ".tscn"):
				var cutscene = load("res://Scenes/Cutscenes/" + songData["cutscene"] + ".tscn").instance()
				add_child(cutscene)
				
				cutscene.connect("finished", self, "start_countdown")
				in_cutscene = true
			else:
				start_countdown()
		else:
			start_countdown()
	else:
		start_countdown()
	
	var modcharts = Directory.new()
	
	modcharts.open(Paths.base_song_path(GameplaySettings.songName))
	
	modcharts.list_dir_begin()
	
	while true:
		var file = modcharts.get_next()
		
		if file == "":
			break
		elif !file.begins_with(".") and (".gd" in file and not ".remap" in file):
			var modchart = load(Paths.base_song_path(GameplaySettings.songName) + file).new()
			add_child(modchart)

func _physics_process(_delta):
	var inst_pos = (AudioHandler.get_node("Inst").get_playback_position() * 1000) + (AudioServer.get_time_since_last_mix() * 1000)
	inst_pos -= AudioServer.get_output_latency() * 1000
	
	if inst_pos > Conductor.songPosition - (AudioServer.get_output_latency() * 1000) + ms_offsync_allowed or inst_pos < Conductor.songPosition - (AudioServer.get_output_latency() * 1000) - ms_offsync_allowed:
		AudioHandler.get_node("Inst").seek(Conductor.songPosition / 1000)
		AudioHandler.get_node("Voices").seek(Conductor.songPosition / 1000)
	
	$Camera2D.zoom = Vector2(lerp(defaultCameraZoom, $Camera2D.zoom.x, 0.95), lerp(defaultCameraZoom, $Camera2D.zoom.y, 0.95))
	
	if $Camera2D.zoom.x < 0.65:
		$Camera2D.zoom = Vector2(0.65, 0.65)
	
	$UI.scale = Vector2(lerp(1, $UI.scale.x, 0.95), lerp(1, $UI.scale.y, 0.95))
	$UI.offset = Vector2(lerp(0, $UI.offset.x, 0.95), lerp(0, $UI.offset.y, 0.95))
	
	var index = 0
	
	for note in noteDataArray:
		if float(note[0]) > Conductor.songPosition + (5000 * GameplaySettings.song_multiplier):
			break
		
		if float(note[0]) < Conductor.songPosition + (2500 * GameplaySettings.song_multiplier):
			var new_note = template_notes[note[5]].duplicate()
			new_note.strum_time = float(note[0])
			new_note.note_data = int(note[1]) % key_count
			new_note.direction = get_node("UI/Player Strums").get_child(new_note.note_data).direction
			new_note.visible = true
			new_note.play_animation("")
			new_note.strum_y = get_node("UI/Player Strums").get_child(new_note.note_data).global_position.y
			
			if "is_alt" in new_note:
				new_note.is_alt = note[6]
			
			if int(note[4]) != null:
				if "character" in new_note:
					new_note.character = note[4]
			
			if float(note[2]) >= Conductor.timeBetweenSteps:
				new_note.is_sustain = true
				new_note.sustain_length = float(note[2])
				new_note.set_held_note_sprites()
				new_note.get_node("Line2D").texture = new_note.held_sprites[NoteFunctions.dir_to_str(new_note.direction)][0]
			
			var is_player_note = true
			
			if note[3] and int(note[1]) % (key_count * 2) >= key_count:
				is_player_note = false
			elif !note[3] and int(note[1]) % (key_count * 2) <= key_count - 1:
				is_player_note = false
				
			if is_player_note:
				new_note.position.x = get_node("UI/Player Strums").get_child(new_note.note_data).position.x
				$"UI/Player Notes".add_child(new_note)
			else:
				new_note.position.x = get_node("UI/Player Strums").get_child(new_note.note_data).position.x
				$"UI/Enemy Notes".add_child(new_note)
			
			new_note.is_player = is_player_note
			new_note.global_position.y = -5000
			
			noteDataArray.remove(index)
		
		index += 1

var align_gameplay_text = "[center]"

var can_leave_game:bool = true

func _process(delta):
	if !in_cutscene:
		Conductor.songPosition += (delta * 1000) * GameplaySettings.song_multiplier
	
	if Input.is_action_just_pressed("restart_song"):
		Scenes.switch_scene("Gameplay")
	
	if counting:
		var prev_counter = counter
		
		if Conductor.songPosition >= (Conductor.timeBetweenBeats * -4) * GameplaySettings.song_multiplier:
			counter = 0
		if Conductor.songPosition >= (Conductor.timeBetweenBeats * -3) * GameplaySettings.song_multiplier:
			counter = 1
		if Conductor.songPosition >= (Conductor.timeBetweenBeats * -2) * GameplaySettings.song_multiplier:
			counter = 2
		if Conductor.songPosition >= (Conductor.timeBetweenBeats * -1) * GameplaySettings.song_multiplier:
			counter = 3
		if Conductor.songPosition >= 0:
			counter = 4
		
		if prev_counter != counter:
			var ready = countdown_node.get_node("Ready")
			var set = countdown_node.get_node("Set")
			var go = countdown_node.get_node("Go")
			var tween = countdown_node.get_node("Tween")
			
			ready.visible = false
			set.visible = false
			go.visible = false
			
			beat_hit(true)
			
			match(counter):
				0:
					AudioHandler.play_audio("Countdown/3")
				1:
					AudioHandler.play_audio("Countdown/2")
					tween.interpolate_property(ready, "modulate", Color(1,1,1,1), Color(1,1,1,0), Conductor.timeBetweenBeats / 1000, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
					tween.start()
					ready.visible = true
				2:
					AudioHandler.play_audio("Countdown/1")
					tween.interpolate_property(set, "modulate", Color(1,1,1,1), Color(1,1,1,0), Conductor.timeBetweenBeats / 1000, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
					tween.start()
					set.visible = true
				3:
					AudioHandler.play_audio("Countdown/Go")
					tween.interpolate_property(go, "modulate", Color(1,1,1,1), Color(1,1,1,0), Conductor.timeBetweenBeats / 1000, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
					tween.start()
					go.visible = true
				4:
					AudioHandler.play_audio("Inst")
					
					if songData["needsVoices"]:
						AudioHandler.play_audio("Voices")
						AudioHandler.get_node("Voices").seek(0)
					
					AudioHandler.get_node("Inst").seek(0) # cool syncing stuff
					
					counting = false
					in_cutscene = false
					
					countdown_node.queue_free()
					
					Conductor.songPosition = 0.0
	
	if Conductor.songPosition > AudioHandler.get_node("Inst").stream.get_length() * 1000 and can_leave_game:
		can_leave_game = false
		
		AudioHandler.get_node("Voices").volume_db = -80
		AudioHandler.get_node("Inst").volume_db = -80
		
		# prevents some bs progess bar issues lol
		$"UI/Progress Bar".visible = false
		
		if GameplaySettings.song_multiplier >= 1 and not Settings.get_data("bot"):
			if Scores.get_song_score(GameplaySettings.songName.to_lower(), GameplaySettings.songDifficulty.to_lower()) < score:
				Scores.set_song_score(GameplaySettings.songName.to_lower(), GameplaySettings.songDifficulty.to_lower(), score)
		
		if GameplaySettings.freeplay:
			Scenes.switch_scene("Freeplay")
		else:
			if len(GameplaySettings.weekSongs) < 1:
				Scenes.switch_scene("Story Mode")
			else:
				GameplaySettings.songName = GameplaySettings.weekSongs[0]
				
				var file = File.new()
				file.open(Paths.song_path(GameplaySettings.songName, GameplaySettings.songDifficulty), File.READ)
				
				GameplaySettings.song = JSON.parse(file.get_as_text()).result["song"]
				
				GameplaySettings.weekSongs.erase(GameplaySettings.weekSongs[0])
				
				Scenes.switch_scene("Gameplay", true)
	
	if Input.is_action_just_pressed("ui_back"):
		if GameplaySettings.freeplay:
			Scenes.switch_scene("Freeplay")
		else:
			Scenes.switch_scene("Story Mode")
	
	if Input.is_action_just_pressed("charting_menu") and Settings.get_data("debug_menus") and not in_cutscene:
		Scenes.switch_scene("Charter")

var curSection:int = 0

var cam_locked:bool = false
var cam_offset:Vector2 = Vector2()

func beat_hit(dumb = false):
	if not counting:
		if Conductor.curBeat % 4 == 0 and Settings.get_data("cameraZooms"):
			$Camera2D.zoom -= Vector2(0.015, 0.015)
			$UI.scale += Vector2(0.02, 0.02)
			$UI.offset += Vector2(-15, -10)
	
	if not dumb:
		if bf != null:
			if bf.is_dancing():
				bf.dance()
		if dad != null:
			if dad.is_dancing():
				dad.dance()
		if gf != null:
			if gf.is_dancing() and dad != gf:
				gf.dance()
	
	var prevSection = curSection
	
	curSection = floor(Conductor.curStep / 16)
	
	if curSection != prevSection and !cam_locked:
		if len(songData["notes"]) - 1 >= curSection:
			if bf and dad:
				if songData["notes"][curSection]["mustHitSection"]:
					$Camera2D.position = stage.get_node("Player Point").position + Vector2(-1 * bf.camOffset.x, bf.camOffset.y) + cam_offset
				else:
					$Camera2D.position = stage.get_node("Dad Point").position + dad.camOffset + cam_offset
	
	if GameplaySettings.song:
		if "song" in GameplaySettings.song:
			var time_left = str(int(AudioHandler.get_node("Inst").stream.get_length() - AudioHandler.get_node("Inst").get_playback_position()))

func update_gameplay_text():
	if total_hit != 0 and total_notes != 0:
		accuracy = (total_hit / total_notes) * 100
	else:
		accuracy = 0
	
	gameplay_text.bbcode_text = align_gameplay_text + (
		"Score: " + str(score) + " | " +
		"Misses: " + str(misses) + " | " +
		"Accuracy: " + str(round(accuracy * 100) / 100) + "%"
	)
	
	if Settings.get_data("bot"):
		gameplay_text.bbcode_text += " | BOT"
	else:
		if misses == 0:
			var funny_add = " | N/A"
			
			if ratings.marvelous > 0:
				funny_add = " | MFC"
			if ratings.sick > 0:
				funny_add = " | SFC"
			if ratings.good > 0:
				funny_add = " | GFC"
			if ratings.bad > 0 or ratings.shit > 0:
				funny_add = " | FC"
			
			gameplay_text.bbcode_text += funny_add
		elif misses <= 10:
			gameplay_text.bbcode_text += " | SDCB"

var rating_textures = [
	load("res://Assets/Images/UI/Ratings/marvelous.png"),
	load("res://Assets/Images/UI/Ratings/sick.png"),
	load("res://Assets/Images/UI/Ratings/good.png"),
	load("res://Assets/Images/UI/Ratings/bad.png"),
	load("res://Assets/Images/UI/Ratings/shit.png")
]

var numbers = [
	load("res://Assets/Images/UI/Ratings/num0.png"),
	load("res://Assets/Images/UI/Ratings/num1.png"),
	load("res://Assets/Images/UI/Ratings/num2.png"),
	load("res://Assets/Images/UI/Ratings/num3.png"),
	load("res://Assets/Images/UI/Ratings/num4.png"),
	load("res://Assets/Images/UI/Ratings/num5.png"),
	load("res://Assets/Images/UI/Ratings/num6.png"),
	load("res://Assets/Images/UI/Ratings/num7.png"),
	load("res://Assets/Images/UI/Ratings/num8.png"),
	load("res://Assets/Images/UI/Ratings/num9.png")
]

var total_notes:int = 0
var total_hit:float = 0.0

func popup_rating(strum_time):
	var timings = [25, 50, 70, 100]
	var scores = [400, 350, 200, 50, -150]
	
	var ms_dif = (strum_time - Conductor.songPosition) / GameplaySettings.song_multiplier
	
	var rating = 4
	
	for i in len(timings):
		if abs(ms_dif) <= timings[i]:
			rating = i
			break
	
	if Settings.get_data("bot"):
		rating = 0
		ms_dif = 0
	
	$"UI/Ratings".visible = true
	$"UI/Ratings/Rating".texture = rating_textures[rating]
	
	var combo_str = str(combo)
	
	for child in get_node("UI/Ratings/Numbers").get_children():
		child.visible = false
	
	for letter in len(combo_str):
		if get_node("UI/Ratings/Numbers/" + str(letter)) != null:
			get_node("UI/Ratings/Numbers/" + str(letter)).visible = true
			get_node("UI/Ratings/Numbers/" + str(letter)).texture = numbers[int(combo_str[letter])]
	
	var ratings_thing = get_node("UI/Ratings")
	
	var tween = get_node("UI/Ratings/Tween")
	ratings_thing.modulate = Color(1,1,1,1)
	ratings_thing.position.y = 354
	tween.interpolate_property(ratings_thing, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.2, 0, 2, Conductor.timeBetweenBeats * 0.001)
	tween.interpolate_property(ratings_thing, "position", Vector2(ratings_thing.position.x, 354), Vector2(ratings_thing.position.x, 380), 0.2 + (Conductor.timeBetweenBeats * 0.001), 0, 2)
	tween.stop_all()
	tween.start()
	
	score += scores[rating]
	
	$"UI/Ratings/Accuracy Text".text = str(round(ms_dif * 100) / 100) + " ms"
	
	if Settings.get_data("bot"):
		$"UI/Ratings/Accuracy Text".text += " (BOT)"
	
	if ms_dif == abs(ms_dif):
		$"UI/Ratings/Accuracy Text".set("custom_colors/default_color", Color(0,1,1))
	else:
		$"UI/Ratings/Accuracy Text".set("custom_colors/default_color", Color(1,0.63,0))
	
	match(rating):
		0,1:
			total_hit += 1
			health += 0.035
			
			if rating == 0:
				ratings.marvelous += 1
			else:
				ratings.sick += 1
		2:
			total_hit += 0.8
			health += 0.015
			ratings.good += 1
		3:
			total_hit += 0.3
			health += 0.005
			ratings.bad += 1
		4:
			health -= 0.075
			ratings.shit += 1
	
	total_notes += 1
	
	update_gameplay_text()
	update_rating_text()

onready var rating_text = $"UI/Gameplay Text/Ratings"

func update_rating_text():
	var ma:float = 0.0
	var pa:float = 0.0
	
	var total:float = ratings.sick + ratings.good + ratings.bad + ratings.shit
	var without_sick:float = ratings.good + ratings.bad + ratings.shit
	
	if total != 0 and ratings.marvelous != 0:
		ma = round(((ratings.marvelous / total) * 100.0)) / 100.0
	
	if without_sick != 0 and (ratings.marvelous != 0 or ratings.sick != 0):
		pa = round((((ratings.marvelous + ratings.sick) / total) * 100.0)) / 100.0
	
	rating_text.text = (
		" Marvelous: " + str(ratings.marvelous) + "\n" +
		" Sick: " + str(ratings.sick) + "\n" +
		" Good: " + str(ratings.good) + "\n" +
		" Bad: " + str(ratings.bad) + "\n" +
		" Shit: " + str(ratings.shit) + "\n" +
		" MA: " + str(ma) + "\n" +
		" PA: " + str(pa) + "\n"
	)

func start_countdown():
	counting = true
	in_cutscene = false
	Scenes.current_scene = "Gameplay"

func note_sort(a, b):
	return a[0] < b[0]
