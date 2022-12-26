extends Node2D

var template_note: Node2D

var template_notes: Dictionary = {}

var stage_string: String = "stage"
var default_camera_zoom: float = 1.05
var default_hud_zoom: float = 1.0

var song_data: Dictionary = {}

var bf: Node2D
var dad: Node2D
var gf: Node2D

var gf_speed: int = 1

var stage: Node2D

var strums: PackedScene

var gameplay_text: Label

var enemy_notes: Node2D
var player_notes: Node2D

var note_data_array: Array = []
var preloaded_notes: Array = []
onready var preload_notes: bool = Settings.get_data('preload_notes')

var misses: int = 0
var combo: int = 0
var score: int = 0

var accuracy: float = 0.0

var key_count: int = 4

var health: float = 1.0

onready var health_bar: Node2D = $"UI/Health Bar"

var player_icon: Sprite
var enemy_icon: Sprite

var counter: int = -1
var counting: bool = false
var in_cutscene: bool = false

onready var countdown_node: Node = $"UI/Countdown"

var bpm_changes: Array = []

var strum_texture: SpriteFrames

var ratings: Dictionary = {
	"marvelous": 0,
	"sick": 0,
	"good": 0,
	"bad": 0,
	"shit": 0
}

var ms_offsync_allowed: float = 20

var player_strums: Node2D
var enemy_strums: Node2D

onready var progress_bar: Node2D = $"UI/Progress Bar"
onready var progress_bar_bar: ProgressBar = progress_bar.get_node("ProgressBar")

onready var camera = $Camera
onready var ui: CanvasLayer = $UI

onready var accuracy_text: Label = ui.get_node("Ratings/Accuracy Text")

onready var ready: Sprite = countdown_node.get_node("Ready")
onready var set: Sprite = countdown_node.get_node("Set")
onready var go: Sprite = countdown_node.get_node("Go")

onready var health_bar_bg: Sprite = health_bar.get_node("Bar/Sprite")

var events: Array = []
var event_nodes: Dictionary = {}
var events_to_do: Array = []

func section_start_time(section: int = 0) -> float:
	var section_position: float = 0.0
	var current_bpm: float = song_data["bpm"]
	
	for i in section:
		if "changeBPM" in song_data.notes[i] and song_data.notes[i]["changeBPM"]: current_bpm = song_data.notes[i]["bpm"]
		section_position += 4.0 * (1000.0 * (60.0 / current_bpm))
	
	return section_position

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	if OS.get_name().to_lower() == "windows":
		ms_offsync_allowed = 30 # because for some reason windows has weird syncing issues that i'm too stupid to fix properly
	
	ms_offsync_allowed *= Globals.song_multiplier
	
	Conductor.safeZoneOffset = 166.6 * Globals.song_multiplier
	song_data = Globals.song
	
	bpm_changes = Conductor.map_bpm_changes(song_data)
	
	if "keyCount" in song_data:
		key_count = int(song_data["keyCount"])
	elif "mania" in song_data:
		match(int(song_data["mania"])):
			1: key_count = 6
			2: key_count = 7
			3: key_count = 9
			_: key_count = 4
	
	song_data["keyCount"] = key_count
	
	if "events" in song_data:
		for event in song_data.events:
			events_to_do.append(event)
	
	Globals.song["keyCount"] = key_count
	
	Globals.key_count = key_count
	Settings.setup_binds()
	
	strum_texture = load("res://Assets/Images/Notes/default/default.res")
	template_notes["default"] = load("res://Scenes/Gameplay/Note.tscn").instance()
	
	strums = load("res://Scenes/Gameplay/Strums/" + str(key_count) + ".tscn")
	
	if strums == null:
		key_count = 4
		Globals.key_count = key_count
		Settings.setup_binds()
		
		strums = load("res://Scenes/Gameplay/Strums/" + str(key_count) + ".tscn")
	
	AudioHandler.stop_audio("Title Music")
	
	if song_data.has('stage'): stage_string = song_data.stage
	
	if "ui_Skin" in song_data:
		song_data["ui_skin"] = song_data["ui_Skin"]
	
	if not "ui_skin" in song_data:
		song_data["ui_skin"] = "default"
	
	var skin_data: Node2D
	
	if "ui_skin" in song_data:
		var skin = song_data["ui_skin"]
		
		skin_data = load("res://Scenes/UI Skins/" + skin + ".tscn").instance()
		if not skin_data: skin_data = load("res://Scenes/UI Skins/default.tscn").instance()
		
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
		
		health_bar_bg.texture = skin_data.health_bar_texture
		
		template_notes["default"].get_node("AnimatedSprite").frames = skin_data.notes_texture
		
		if "note_scale" in skin_data: template_notes["default"].scale *= Vector2(skin_data.note_scale, skin_data.note_scale)
		if "note_hold_scale" in skin_data: template_notes["default"].get_node("Line2D").scale = skin_data.note_hold_scale
		
		if "countdown_scale" in skin_data:
			ready.scale = Vector2(skin_data.countdown_scale, skin_data.countdown_scale)
			set.scale = Vector2(skin_data.countdown_scale, skin_data.countdown_scale)
			go.scale = Vector2(skin_data.countdown_scale, skin_data.countdown_scale)
		
		ready.texture = skin_data.ready_texture
		set.texture = skin_data.set_texture
		go.texture = skin_data.go_texture
		
		if "rating_scale" in skin_data: cool_rating.scale = Vector2(skin_data.rating_scale, skin_data.rating_scale)
		
		if "number_scale" in skin_data:
			for child in ratings_thing.get_node("Numbers").get_children():
				child.scale = Vector2(skin_data.number_scale, skin_data.number_scale)
		
		for texture in Globals.held_sprites:
			Globals.held_sprites[texture][0] = load(skin_data.held_note_path + texture + " hold0000.png")
			Globals.held_sprites[texture][1] = load(skin_data.held_note_path + texture + " hold end0000.png")
		
		strum_texture = skin_data.strums_texture
	
	var gf_name: String = "gf"
	
	if "gf" in song_data:
		gf_name = song_data["gf"]
	elif "gfVersion" in song_data:
		gf_name = song_data["gfVersion"]
	elif "player3" in song_data:
		gf_name = song_data["player3"]
	
	song_data["gf"] = gf_name

	if !Settings.get_data("ultra_performance"): stage = Globals.load_stage(stage_string, "stage").instance()
	else:
		var stage_obj = load(Paths.stage_path(""))
		stage = stage_obj.instance()
	
	var gd_zoom: float = Globals.hxzoom_to_gdzoom(stage.camZoom)
	camera.zoom = Vector2(gd_zoom, gd_zoom)
	default_camera_zoom = stage.camZoom
	
	if not Settings.get_data("ultra_performance"):
		player_point = stage.get_node("Player Point")
		dad_point = stage.get_node("Dad Point")
		gf_point = stage.get_node("GF Point")
		
		bf = Globals.load_character(song_data["player1"], 'bf').instance()
		bf.position = player_point.position
		bf.scale.x *= -1.0
		
		dad = Globals.load_character(song_data["player2"], 'dad').instance()
		dad.position = dad_point.position
		
		gf = Globals.load_character(gf_name, 'gf').instance()
		gf.position = gf_point.position
	
	add_child(stage)
	
	if not Settings.get_data("ultra_performance"):
		add_child(gf)
		add_child(bf)
		
		if not song_data["player2"]:
			dad.queue_free()
			dad = gf
		else: add_child(dad)
	
	if not Settings.get_data("ultra_performance"):
		var health_bar_bar = health_bar.get_node("Bar/ProgressBar")
		health_bar_bar.get("custom_styles/fg").bg_color = bf.health_bar_color
		health_bar_bar.get("custom_styles/bg").bg_color = dad.health_bar_color
	
	player_icon = health_bar.get_node("Player")
	enemy_icon = health_bar.get_node("Opponent")
	
	if !Settings.get_data("ultra_performance"):
		player_icon.texture = bf.health_icon
		Globals.detect_icon_frames(player_icon)
		
		enemy_icon.texture = dad.health_icon
		Globals.detect_icon_frames(enemy_icon)
	
	if !Settings.get_data("ultra_performance"):
		camera.smoothing_enabled = false
		camera.position = stage.get_node("Player Point").position + Vector2(-1 * bf.camOffset.x, bf.camOffset.y)
	
	for section in song_data["notes"]:
		for note in section["sectionNotes"]:
			if note[1] != -1:
				if note.size() == 3: note.push_back(0)
				
				var type:String = "default"
				
				if note[3] is Array: note[3] = note[3][0]
				elif note[3] is String:
					type = note[3]
					
					note[3] = 0
					note.push_back(type)
				
				if note.size() == 4: note.push_back("default")
				
				if note[4]:
					if note[4] is String:
						type = note[4]
						
						if not type in template_notes:
							var loaded_note = load("res://Scenes/Gameplay/Note Types/" + type + ".tscn")
							
							if loaded_note: template_notes[type] = loaded_note.instance()
							else: template_notes[type] = template_notes["default"]
				
				if not "altAnim" in section: section["altAnim"] = false
				if not note[3]: note[3] = 0
				
				note_data_array.push_back([float(note[0]) + Settings.get_data("offset") + (AudioServer.get_output_latency() * 1000), note[1], note[2], bool(section["mustHitSection"]), int(note[3]), type, bool(section["altAnim"])])
			else:
				if note.size() >= 5: events_to_do.append([note[2], float(note[0]), note[3], note[4]])
	
	note_data_array.sort_custom(self, "note_sort")
	
	inst.stream = null
	inst.stream = Globals.load_song_audio('Inst')
	inst.pitch_scale = Globals.song_multiplier
	inst.volume_db = 0
	
	if song_data["needsVoices"]:
		voices.stream = null
		voices.stream = Globals.load_song_audio('Voices')
		voices.pitch_scale = Globals.song_multiplier
		voices.volume_db = 0
	
	if !Settings.get_data("custom_scroll_bool"): Globals.scroll_speed = float(song_data["speed"])
	else: Globals.scroll_speed = Settings.get_data("custom_scroll")
	
	Globals.scroll_speed /= Globals.song_multiplier
	
	Conductor.songPosition = 0.0
	Conductor.curBeat = 0
	Conductor.curStep = 0
	Conductor.change_bpm(float(song_data["bpm"]), bpm_changes)
	Conductor.connect("beat_hit", self, "beat_hit")
	
	gameplay_text = ui.get_node("Gameplay Text/Gameplay Text")
	
	player_notes = ui.get_node("Player Notes")
	enemy_notes = ui.get_node("Enemy Notes")
	
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
	
	ui.add_child(player_strums)
	ui.add_child(enemy_strums)
	
	if Settings.get_data("downscroll"):
		player_strums.position.y = 620
		enemy_strums.position.y = 620
		gameplay_text.rect_position.y = 115
		health_bar.position.y = 56
		progress_bar.position.y = 698
	else:
		player_strums.position.y = 100
		enemy_strums.position.y = 100
		gameplay_text.rect_position.y = 682
		health_bar.position.y = 623
		progress_bar.position.y = 6
	
	if Settings.get_data("middlescroll"):
		player_strums.position.x = 470
		ratings_thing.position.x = 253
		
		enemy_strums.visible = false
		enemy_notes.visible = false
	
	player_notes.position.x = player_strums.position.x
	enemy_notes.position.x = enemy_strums.position.x
	
	player_notes.scale = player_strums.scale
	enemy_notes.scale = enemy_strums.scale
	
	Conductor.songPosition = (Conductor.timeBetweenBeats * -4.0) * Globals.song_multiplier
	
	update_gameplay_text()
	
	var freeplay_song_data: bool = false
	if "cutscene_in_freeplay" in song_data: freeplay_song_data = song_data.cutscene_in_freeplay
	
	if Settings.get_data("freeplay_cutscenes"): freeplay_song_data = true
	
	if (!Globals.freeplay or freeplay_song_data) and Globals.do_cutscenes and !Settings.get_data("ultra_performance"):
		if "cutscene" in song_data:
			if ResourceLoader.exists("res://Scenes/Cutscenes/" + song_data["cutscene"] + ".tscn"):
				camera.smoothing_enabled = true
				
				var cutscene = load("res://Scenes/Cutscenes/" + song_data["cutscene"] + ".tscn").instance()
				add_child(cutscene)
				
				cutscene.connect("finished", self, "start_countdown")
				in_cutscene = true
			else: start_countdown()
		else: start_countdown()
	else: start_countdown()
	
	var event_file: File = File.new()
	
	if not Settings.get_data("ultra_performance"):
		event_file.open(Paths.base_song_path(Globals.songName) + "events.json", File.READ)
		
		if event_file.file_exists(Paths.base_song_path(Globals.songName) + "events.json"):
			var event_data = JSON.parse(event_file.get_as_text()).result.song
			
			if "events" in event_data or "notes" in event_data:
				if "events" in event_data:
					for event in event_data.events: events_to_do.append(event)
				
				if "notes" in event_data:
					for section in event_data.notes:
						for note in section.sectionNotes:
							if note[1] == -1: events_to_do.append([note[2], float(note[0]), note[3], note[4]])
				
		for event in events_to_do:
			# is psych event lmao
			if (event[0] is float or event[0] is int) and event[1] is Array:
				for psych_event in event[1]: events.append([psych_event[0], event[0], psych_event[1], psych_event[2]])
			else: events.append(event)
			
			var event_name: String = events[len(events) - 1][0]
			
			if !event_nodes.has(event_name) and event_file.file_exists("res://Scenes/Events/" + event_name.to_lower() + ".tscn"):
				event_nodes[event_name] = load("res://Scenes/Events/" + event_name.to_lower() + ".tscn").instance()
				add_child(event_nodes[event_name])
		
		event_file.close()
	
	events.sort_custom(self, "event_sort")
	
	for event in events:
		if event_nodes.has(event[0]):
			Globals.emit_signal("event_setup", event)
			event_nodes[event[0]].setup_event(event[2], event[3])
	
	var modcharts: Directory = Directory.new()
	modcharts.open(Paths.base_song_path(Globals.songName))
	modcharts.list_dir_begin()
	
	while true:
		var file = modcharts.get_next()
		
		if file == "":
			break
		elif !file.begins_with(".") and file.ends_with(".tscn"):
			var modchart = load(Paths.base_song_path(Globals.songName) + file).instance()
			add_child(modchart)
	
	Discord.update_presence("Starting " + song_data["song"] + " (" + Globals.songDifficulty + ")")
	
	add_child(presence_timer)
	
	presence_timer.start(0.5 / clamp(Globals.song_multiplier, 0.001, 5))
	presence_timer.connect("timeout", self, "update_presence")
	
	if preload_notes:
		for note in note_data_array:
			var is_player_note: bool = true
			
			if note[3] and int(note[1]) % (key_count * 2) >= key_count: is_player_note = false
			elif !note[3] and int(note[1]) % (key_count * 2) <= key_count - 1: is_player_note = false
			
			var new_note = template_notes[note[5]].duplicate()
			new_note.strum_time = float(note[0])
			new_note.note_data = int(note[1]) % key_count
			new_note.direction = player_strums.get_child(new_note.note_data).direction
			new_note.visible = true
			new_note.play_animation("")
			new_note.strum_y = player_strums.get_child(new_note.note_data).global_position.y
			
			if "is_alt" in new_note: new_note.is_alt = note[6]
			if int(note[4]) and "character" in new_note: new_note.character = note[4]
			
			if float(note[2]) >= Conductor.timeBetweenSteps:
				new_note.is_sustain = true
				new_note.sustain_length = float(note[2])
				new_note.set_held_note_sprites()
				new_note.get_node("Line2D").texture = new_note.held_sprites[Globals.dir_to_str(new_note.direction)][0]
				
			if is_player_note: new_note.position.x = player_strums.get_child(new_note.note_data).position.x
			else: new_note.position.x = player_strums.get_child(new_note.note_data).position.x
			
			new_note.is_player = is_player_note
			new_note.position.y = -5000
			
			note_data_array.remove(note_data_array.find(note))
			preloaded_notes.push_back(new_note)
		
		preloaded_notes.sort_custom(self, 'preloaded_sort')

var presence_timer: Timer = Timer.new()

onready var inst = AudioHandler.get_node("Inst")
onready var voices = AudioHandler.get_node("Voices")

func _physics_process(_delta: float) -> void:
	var inst_pos: float = (inst.get_playback_position() + AudioServer.get_time_since_last_mix()) * 1000.0
	
	if abs(inst_pos - Conductor.songPosition) > ms_offsync_allowed:
		inst.seek(Conductor.songPosition / 1000.0)
		voices.seek(Conductor.songPosition / 1000.0)
	
	if voices.stream and inst.get_playback_position() * 1000.0 > voices.stream.get_length() * 1000.0:
		voices.volume_db = -80
	
	load_potential_notes()
	
	for event in events:
		if Conductor.songPosition >= event[1]:
			if event_nodes.has(event[0]):
				Globals.emit_signal("event_processed", event)
				event_nodes[event[0]].process_event(event[2], event[3])
			
			events.erase(event)
		else: break

var can_leave_game:bool = true

onready var bot = Settings.get_data("bot")
onready var miss_sounds = Settings.get_data("miss_sounds")

var camera_zooming: bool = false

func _process(delta: float) -> void:
	if camera_zooming:
		camera.zoom = Vector2(
			lerp(camera.zoom.x, Globals.hxzoom_to_gdzoom(default_camera_zoom), v(0.05, delta)),
			lerp(camera.zoom.y, Globals.hxzoom_to_gdzoom(default_camera_zoom), v(0.05, delta))
		)
	
		if camera.zoom.x < 0.65: camera.zoom = Vector2(0.65, 0.65)
		
		ui.scale = Vector2(lerp(ui.scale.x, default_hud_zoom, v(0.05, delta)), lerp(ui.scale.y, default_hud_zoom, v(0.05, delta)))
		ui.offset = Vector2(lerp(ui.offset.x, -650 * (default_hud_zoom - 1), v(0.05, delta)), lerp(ui.offset.y, -400 * (default_hud_zoom - 1), v(0.05, delta)))
	
	if !in_cutscene: Conductor.songPosition += (delta * 1000.0) * Globals.song_multiplier
	if Input.is_action_just_pressed("restart_song"): Scenes.switch_scene("Gameplay")
	
	if counting:
		var prev_counter: int = counter
		
		if Conductor.curBeat >= 0: counter = 4
		# increment counter every beat basically (used to be -4.0 + counter but that no work ig so ae)
		elif Conductor.curBeat >= -3.0 + counter: counter += 1
		
		if prev_counter != counter:
			var tween = countdown_node.get_node("Tween")
			
			ready.visible = false
			set.visible = false
			go.visible = false
			
			beat_hit(true)
			
			match(counter):
				0: AudioHandler.play_audio("Countdown/3")
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
					
					if song_data["needsVoices"]:
						AudioHandler.play_audio("Voices")
						voices.seek(0)
					
					inst.seek(0) # cool syncing stuff
					
					counting = false
					in_cutscene = false
					
					countdown_node.queue_free()
					Conductor.songPosition = 0.0
	
	if Conductor.songPosition > inst.stream.get_length() * 1000.0 and can_leave_game:
		can_leave_game = false
		
		voices.volume_db = -80
		inst.volume_db = -80
		
		# prevents some bs progess bar issues lol
		progress_bar.visible = false
		
		if Globals.song_multiplier >= 1 and not Settings.get_data("bot"):
			if Scores.get_song_score(Globals.songName.to_lower(), Globals.songDifficulty.to_lower()) < score:
				Scores.set_song_score(Globals.songName.to_lower(), Globals.songDifficulty.to_lower(), score)
		
		if Globals.freeplay:
			Scenes.switch_scene("Freeplay")
		else:
			if len(Globals.weekSongs) < 1:
				Scenes.switch_scene("Story Mode")
			else:
				Globals.songName = Globals.weekSongs[0]
				
				var file = File.new()
				file.open(Paths.song_path(Globals.songName, Globals.songDifficulty), File.READ)
				
				Globals.song = JSON.parse(file.get_as_text()).result["song"]
				
				Globals.weekSongs.erase(Globals.weekSongs[0])
				
				Scenes.switch_scene("Gameplay", true)
	
	if Input.is_action_just_pressed("ui_back"):
		if Globals.freeplay:
			Scenes.switch_scene("Freeplay")
		else:
			Scenes.switch_scene("Story Mode")
	
	if Input.is_action_just_pressed("charting_menu") and Settings.get_data("debug_menus") and not in_cutscene:
		Scenes.switch_scene("Charter")
	
	for note in enemy_notes.get_children():
		if note.strum_time > Conductor.songPosition:
			continue
		
		if note.should_hit and !note.being_pressed:
			var strum = note.strum
			
			if dad:
				if note.is_alt and dad.has_anim("sing" + Globals.dir_to_animstr(note.direction).to_upper() + "-alt", note.character):
					if note.character != 0:
						dad.play_animation("sing" + Globals.dir_to_animstr(note.direction).to_upper() + "-alt", true, note.character)
					else:
						dad.play_animation("sing" + Globals.dir_to_animstr(note.direction).to_upper() + "-alt", true)
				else:
					if note.character != 0:
						dad.play_animation("sing" + Globals.dir_to_animstr(note.direction).to_upper(), true, note.character)
					else:
						dad.play_animation("sing" + Globals.dir_to_animstr(note.direction).to_upper(), true)
				
				dad.timer = 0
			
			if note.opponent_note_glow:
				strum.play_animation("static")
				strum.play_animation("confirm")
			
			voices.volume_db = 0
			
			Globals.emit_signal("enemy_note_hit", note, note.note_data, note.name, note.character)
			Globals.emit_signal("note_hit", note, note.note_data, note.name, note.character, false)
			
			note.note_hit()
			
			if note.is_sustain:
				note.being_pressed = true
			
			camera_zooming = true
		
		if !note.is_sustain or ("should_hit" in note and !note.should_hit):
			note.queue_free()
	
	if !bot:
		for note in player_notes.get_children():
			# skip this one
			if Conductor.songPosition < note.strum_time + Conductor.safeZoneOffset:
				continue
			
			if !note.being_pressed:
				if note.should_hit and !note.cant_miss:
					if bf:
						if note.character != 0:
							bf.play_animation("sing" + Globals.dir_to_animstr(note.direction).to_upper() + "miss", true, note.character)
						else:
							bf.play_animation("sing" + Globals.dir_to_animstr(note.direction).to_upper() + "miss", true)
						
						bf.timer = 0
					
					misses += 1
					score -= 10
					total_notes += 1
					
					# -2.25 & -2.75 for etterna mode
					if note.is_sustain and note.sustain_length != note.og_sustain_length: total_hit += -0.25
					else: total_hit += -0.75
					
					health -= note.miss_damage
					
					if combo >= 10 and gf: gf.play_animation("sad", true)
					combo = 0
					
					voices.volume_db = -500
					update_gameplay_text()
					
					if miss_sounds: AudioHandler.play_audio("Misses/" + str(round(rand_range(1,3))))
					
					Globals.emit_signal("note_miss", note, note.note_data, note.name, note.character)
					note.note_miss()
				
				note.queue_free()

var curSection: int = 0

var cam_locked: bool = false
var cam_offset: Vector2 = Vector2()

onready var player_point: Node2D
onready var dad_point: Node2D
onready var gf_point: Node2D

func beat_hit(dumb = false):
	if camera_zooming:
		if not counting:
			if Conductor.curBeat % 4 == 0 and Settings.get_data("cameraZooms"):
				camera.zoom -= Vector2(0.015, 0.015)
				ui.scale += Vector2(0.02, 0.02)
				ui.offset += Vector2(-650 * 0.02, -400 * 0.02)
	
	var prevSection = curSection
	
	curSection = floor(Conductor.curStep / 16)
	
	var is_alt:bool = false
	
	if curSection != prevSection and !cam_locked:
		if len(song_data["notes"]) - 1 >= curSection:
			if "altAnim" in song_data["notes"][curSection]:
				is_alt = song_data["notes"][curSection]["altAnim"]
	
	if not dumb:
		if bf:
			if bf.is_dancing():
				if "anim_player" in bf:
					bf.dance(null, is_alt)
				else:
					bf.dance()
		if dad:
			if dad.is_dancing() and dad != gf:
				if "anim_player" in dad:
					dad.dance(null, is_alt)
				else:
					dad.dance()
		if gf:
			if gf.is_dancing() and Conductor.curBeat % gf_speed == 0:
				if "anim_player" in gf:
					gf.dance(null, is_alt)
				else:
					gf.dance()
	
	if curSection != prevSection and !cam_locked:
		if len(song_data["notes"]) - 1 >= curSection:
			if bf and dad:
				camera.smoothing_enabled = true
				
				if song_data["notes"][curSection]["mustHitSection"]:
					camera.position = player_point.position + Vector2(-1 * bf.camOffset.x, bf.camOffset.y) + cam_offset
					progress_bar_bar.get("custom_styles/fg").bg_color = bf.health_bar_color
				else:
					camera.position = dad_point.position + dad.camOffset + cam_offset
					progress_bar_bar.get("custom_styles/fg").bg_color = dad.health_bar_color
	
	if Globals.song:
		if "song" in Globals.song:
			var time_left = str(int(inst.stream.get_length() - inst.get_playback_position()))

var string_accuracy: String = "???"

func update_gameplay_text() -> void:
	if total_hit != 0 and total_notes != 0: accuracy = clamp((total_hit / total_notes) * 100.0, 0.0, INF)
	else: accuracy = 0.0
	
	string_accuracy = str(floor(accuracy * 1000.0) / 1000.0)
	
	gameplay_text.text = ( "<  " +
		"Score:" + str(score) + " ~ " +
		"Misses:" + str(misses) + " ~ " +
		"Accuracy:" + string_accuracy + "%"
	)
	
	if bot: gameplay_text.text += " ~ BOT"
	else:
		# loosely based on kade's etterna shit i think
		var wife_conditions:Array = [
			[accuracy >= 99.9935, "AAAAA"],
			[accuracy >= 99.955, "AAAA"],
			[accuracy >= 99.70, "AAA"],
			[accuracy >= 93, "AA"],
			[accuracy >= 80, "A"],
			[accuracy >= 70, "B"],
			[accuracy >= 60, "C"],
			[accuracy >= 50, "D"],
			[accuracy < 50, "F"]
		]
		
		var rating: String = "F"
		
		for condition in wife_conditions:
			if condition[0]:
				rating = condition[1]
				break
		
		gameplay_text.text += " ~ Rating:" + rating
		
		if misses == 0:
			var funny_add:String = ""
			
			if ratings.marvelous > 0: funny_add = " [MFC]"
			if ratings.sick > 0: funny_add = " [SFC]"
			if ratings.good > 0: funny_add = " [GFC]"
			if ratings.bad > 0 or ratings.shit > 0: funny_add = " [FC]"
			
			gameplay_text.text += funny_add
		elif misses < 10: gameplay_text.text += " [SDCB]"
	
	gameplay_text.text += "  >"

var rating_textures: Array = [
	load("res://Assets/Images/UI/Ratings/marvelous.png"),
	load("res://Assets/Images/UI/Ratings/sick.png"),
	load("res://Assets/Images/UI/Ratings/good.png"),
	load("res://Assets/Images/UI/Ratings/bad.png"),
	load("res://Assets/Images/UI/Ratings/shit.png")
]

var numbers: Array = [
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

var total_notes: int = 0
var total_hit: float = 0.0

onready var numbers_obj: Node2D = get_node("UI/Ratings/Numbers")
onready var ratings_thing: Node2D = get_node("UI/Ratings")
onready var cool_rating: Sprite = ratings_thing.get_node("Rating")
onready var tween: Tween = get_node("UI/Ratings/Tween")

func popup_rating(strum_time: float) -> void:
	# etterna judge 4 (old was LE haxe timings)
	var timings: Array = [22.5, 45.0, 90.0, 135.0] # [25.0, 50.0, 70.0, 100.0]
	
	var scores: Array = [400.0, 350.0, 200.0, 50.0, -150.0]
	var ms_dif: float = (strum_time - Conductor.songPosition) / Globals.song_multiplier
	var rating: int = 4
	
	for i in len(timings):
		if abs(ms_dif) <= timings[i]:
			rating = i
			break
	
	if bot:
		rating = 0
		ms_dif = 0.0
	
	ratings_thing.visible = true
	cool_rating.texture = rating_textures[rating]
	
	var combo_str = str(combo)
	
	for child in numbers_obj.get_children():
		child.visible = false
	
	for letter in len(combo_str):
		var number = get_node("UI/Ratings/Numbers/" + str(letter))
		
		if number:
			number.visible = true
			number.texture = numbers[int(combo_str[letter])]
	
	ratings_thing.modulate = Color(1,1,1,1)
	ratings_thing.position.y = 354
	tween.interpolate_property(ratings_thing, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.2, 0, 2, Conductor.timeBetweenBeats * 0.001)
	tween.interpolate_property(ratings_thing, "position", Vector2(ratings_thing.position.x, 354), Vector2(ratings_thing.position.x, 380), 0.2 + (Conductor.timeBetweenBeats * 0.001), 0, 2)
	tween.stop_all()
	tween.start()
	
	score += scores[rating]
	
	accuracy_text.text = str(round(ms_dif * 100.0) / 100.0) + " ms"
	if bot: accuracy_text.text += " (BOT)"
	
	if ms_dif == abs(ms_dif): accuracy_text.set("custom_colors/font_color", Color(0.0, 1.0, 1.0))
	else: accuracy_text.set("custom_colors/font_color", Color(1.0, 0.63, 0.0))
	
	match(rating):
		0, 1:
			if rating == 0:
				if abs(ms_dif) <= 5: total_hit += 1
				else: total_hit += 0.99
				health += 0.035
				ratings.marvelous += 1
			else:
				total_hit += 0.85
				health += 0.02
				ratings.sick += 1
		2:
			health += 0.01
			total_hit += 0.7
			ratings.good += 1
		3:
			health -= 0.05
			total_hit += 0.25
			ratings.bad += 1
		4:
			health -= 0.125
			total_hit += -0.1
			ratings.shit += 1
	
	total_notes += 1
	
	update_gameplay_text()
	update_rating_text()

onready var rating_text: Label = $"UI/Gameplay Text/Ratings"

func update_rating_text() -> void:
	var ma: float = 0.0
	var pa: float = 0.0
	
	var total: float = ratings.sick + ratings.good + ratings.bad + ratings.shit
	var without_sick: float = ratings.good + ratings.bad + ratings.shit
	
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

func start_countdown() -> void:
	counting = true
	in_cutscene = false
	Scenes.current_scene = "Gameplay"

# sorting
func note_sort(a: Array, b: Array) -> bool: return a[0] < b[0]
func event_sort(a: Array, b: Array) -> bool: return a[1] < b[1]
func preloaded_sort(a, b) -> bool: return a.strum_time < b.strum_time
# 60 fps lerp to unfixed lerp
func v(value_60: float, delta: float) -> float: return delta * (value_60 / (1.0 / 60.0))

func update_presence() -> void:
	if !in_cutscene and inst.stream: Discord.update_presence("Playing " + song_data["song"] + " (" + Globals.songDifficulty + ")", "Time Left: " + Globals.format_time(inst.stream.get_length() - (Conductor.songPosition / 1000.0)), song_data["player2"], song_data["player2"])
	else: Discord.update_presence("In Cutscene in " + song_data["song"] + " (" + Globals.songDifficulty + ")", "", song_data["player2"], song_data["player2"])

func load_potential_notes() -> void:
	for note in note_data_array:
		if float(note[0]) > Conductor.songPosition + (2500 * Globals.song_multiplier): break
		
		var is_player_note: bool = true
		
		if note[3] and int(note[1]) % (key_count * 2) >= key_count: is_player_note = false
		elif !note[3] and int(note[1]) % (key_count * 2) <= key_count - 1: is_player_note = false
		
		var should_spawn: bool = true
		
		if Settings.get_data("ultra_performance") and !is_player_note and Settings.get_data("middlescroll"):
			should_spawn = false
			note_data_array.remove(note_data_array.find(note))
		
		if should_spawn:
			var new_note = template_notes[note[5]].duplicate()
			new_note.strum_time = float(note[0])
			new_note.note_data = int(note[1]) % key_count
			new_note.direction = player_strums.get_child(new_note.note_data).direction
			new_note.visible = true
			new_note.play_animation("")
			new_note.strum_y = player_strums.get_child(new_note.note_data).global_position.y
			
			if "is_alt" in new_note: new_note.is_alt = note[6]
			if int(note[4]) and "character" in new_note: new_note.character = note[4]
			
			if float(note[2]) >= Conductor.timeBetweenSteps:
				new_note.is_sustain = true
				new_note.sustain_length = float(note[2])
				new_note.set_held_note_sprites()
				new_note.get_node("Line2D").texture = new_note.held_sprites[Globals.dir_to_str(new_note.direction)][0]
				
			if is_player_note:
				new_note.position.x = player_strums.get_child(new_note.note_data).position.x
				player_notes.add_child(new_note)
			else:
				new_note.position.x = player_strums.get_child(new_note.note_data).position.x
				enemy_notes.add_child(new_note)
			
			new_note.is_player = is_player_note
			new_note.position.y = -5000
			
			note_data_array.remove(note_data_array.find(note))
		else: break
	
	for note in preloaded_notes:
		if float(note.strum_time) < Conductor.songPosition + (2500.0 * Globals.song_multiplier):
			if note.is_player: player_notes.add_child(note)
			else: enemy_notes.add_child(note)
			
			preloaded_notes.remove(preloaded_notes.find(note))
		else: break
