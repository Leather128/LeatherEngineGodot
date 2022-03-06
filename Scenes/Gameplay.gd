extends Node2D

const template_note = preload("res://Scenes/Gameplay/Note.tscn")

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
var counting = true

onready var countdown_node = $"UI/Countdown"

var bpm_changes = []

func section_start_time(section = 0):
	var coolPos:float = 0.0
	
	var good_bpm = Conductor.bpm
	
	for i in section:
		if "changeBPM" in songData.notes[i]:
			if songData.notes[i]["changeBPM"] == true:
				good_bpm = songData.notes[i]["bpm"]
		
		coolPos += 4 * (1000 * (60 / good_bpm))
	
	return coolPos

func _ready():
	songData = GameplaySettings.song
	
	for section in songData["notes"]:
		if "changeBPM" in section:
			if section["changeBPM"]:
				bpm_changes.append([section_start_time(songData["notes"].find(section)), float(section["bpm"])])
	
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
	
	GameplaySettings.key_count = key_count
	Keybinds.setup_Binds()
	
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
	
	var stageObj = load(Paths.stage_path(stageString))
	
	if stageObj == null:
		stageObj = load(Paths.stage_path("stage"))
	
	stage = stageObj.instance()
	add_child(stage)
	
	var zoomThing = 1 - stage.camZoom
	var goodZoom = 1 + zoomThing
	
	$Camera2D.zoom = Vector2(goodZoom, goodZoom)
	defaultCameraZoom = goodZoom

	var gfName:String = "gf"
	
	if "gf" in songData:
		gfName = songData["gf"]
	elif "gfVersion" in songData:
		gfName = songData["gfVersion"]
	elif "player3" in songData:
		gfName = songData["player3"]
	
	songData["gf"] = gfName
	
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
	
	health_bar.get_node("Bar/ProgressBar").get("custom_styles/fg").bg_color = bf.health_bar_color
	health_bar.get_node("Bar/ProgressBar").get("custom_styles/bg").bg_color = dad.health_bar_color
	
	player_icon = health_bar.get_node("Player")
	enemy_icon = health_bar.get_node("Opponent")
	
	player_icon.texture = bf.health_icon
	
	if player_icon.texture.get_width() <= 300:
		player_icon.hframes = 2
	elif player_icon.texture.get_width() <= 150:
		player_icon.hframes = 1
	
	enemy_icon.texture = dad.health_icon
	
	if enemy_icon.texture.get_width() <= 300:
		enemy_icon.hframes = 2
	elif enemy_icon.texture.get_width() <= 150:
		enemy_icon.hframes = 1
	
	$Camera2D.position = stage.get_node("Player Point").position + Vector2(-1 * bf.camOffset.x, bf.camOffset.y)
	
	for section in songData["notes"]:
		for note in section["sectionNotes"]:
			if note[1] != -1:
				noteDataArray.push_back([float(note[0]) + Settings.get_data("offset"), note[1], note[2], bool(section["mustHitSection"])])
	
	AudioHandler.get_node("Inst").stream = load("res://Assets/Songs/" + GameplaySettings.songName.to_lower() + "/Inst.ogg")
	
	if songData["needsVoices"]:
		AudioHandler.get_node("Voices").stream = load("res://Assets/Songs/" + GameplaySettings.songName.to_lower() + "/Voices.ogg")
	
	GameplaySettings.scroll_speed = float(songData["speed"])
	
	Conductor.songPosition = 0
	Conductor.curBeat = 0
	Conductor.curStep = 0
	Conductor.change_bpm(float(songData["bpm"]), bpm_changes)
	Conductor.connect("beat_hit", self, "beat_hit")
	
	var uiNode = $UI
	
	gameplay_text = uiNode.get_node("Gameplay Text/Gameplay Text")
	
	player_notes = uiNode.get_node("Player Notes")
	enemy_notes = uiNode.get_node("Enemy Notes")
	
	var player_strums = strums.instance()
	player_strums.name = "Player Strums"
	player_strums.is_player = true
	player_strums.position.x = 857
	uiNode.add_child(player_strums)
	
	var enemy_strums = strums.instance()
	enemy_strums.name = "Enemy Strums"
	enemy_strums.is_player = false
	enemy_strums.position.x = 84
	
	for strum in enemy_strums.get_children():
		strum.enemy_strum = true
	
	uiNode.add_child(enemy_strums)
	
	if Settings.get_data("downscroll"):
		player_strums.position.y = 640
		enemy_strums.position.y = 640
		gameplay_text.rect_position.y = 127
		health_bar.position.y = 56
	else:
		player_strums.position.y = 75
		enemy_strums.position.y = 75
		gameplay_text.rect_position.y = 673
		health_bar.position.y = 603
	
	if Settings.get_data("middlescroll"):
		player_strums.position.x = 470
		$"UI/Ratings".position.x = 253
		
		enemy_strums.visible = false
		enemy_notes.visible = false
	
	player_notes.position.x = player_strums.position.x
	enemy_notes.position.x = enemy_strums.position.x
	
	player_notes.scale = player_strums.scale
	enemy_notes.scale = enemy_strums.scale
	
	Conductor.songPosition = Conductor.timeBetweenBeats * -4
	
	update_gameplay_text()

func _physics_process(delta):
	var inst_pos = (AudioHandler.get_node("Inst").get_playback_position() * 1000) + (AudioServer.get_time_since_last_mix() * 1000)
	
	if inst_pos > Conductor.songPosition + 20 or inst_pos < Conductor.songPosition - 20:
		AudioHandler.get_node("Inst").seek(Conductor.songPosition / 1000)
		AudioHandler.get_node("Voices").seek(Conductor.songPosition / 1000)
	
	$Camera2D.zoom = Vector2(lerp(defaultCameraZoom, $Camera2D.zoom.x, 0.95), lerp(defaultCameraZoom, $Camera2D.zoom.y, 0.95))
	
	$UI.scale = Vector2(lerp(1, $UI.scale.x, 0.95), lerp(1, $UI.scale.y, 0.95))
	$UI.offset = Vector2(lerp(0, $UI.offset.x, 0.95), lerp(0, $UI.offset.y, 0.95))

var align_gameplay_text = "[center]"

func _process(delta):
	Conductor.songPosition += delta * 1000
	
	if counting:
		var prev_counter = counter
		
		if Conductor.songPosition >= Conductor.timeBetweenBeats * -4:
			counter = 0
		if Conductor.songPosition >= Conductor.timeBetweenBeats * -3:
			counter = 1
		if Conductor.songPosition >= Conductor.timeBetweenBeats * -2:
			counter = 2
		if Conductor.songPosition >= Conductor.timeBetweenBeats * -1:
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
					
					countdown_node.queue_free()
	
	if Conductor.songPosition > AudioHandler.get_node("Inst").stream.get_length() * 1000:
		if GameplaySettings.freeplay:
			Scenes.switch_scene("Freeplay")
		else:
			Scenes.switch_scene("Main Menu")
	
	if Input.is_action_just_pressed("ui_back"):
		if GameplaySettings.freeplay:
			Scenes.switch_scene("Freeplay")
		else:
			Scenes.switch_scene("Main Menu")
	
	if Input.is_action_just_pressed("charting_menu"):
		Scenes.switch_scene("Charter")
	
	var index = 0
	
	for note in noteDataArray:
		if float(note[0]) > Conductor.songPosition + 5000:
			break
		
		if float(note[0]) < Conductor.songPosition + 2500:
			var new_note = template_note.instance()
			new_note.strum_time = float(note[0])
			new_note.note_data = int(note[1]) % key_count
			new_note.direction = get_node("UI/Player Strums").get_child(new_note.note_data).direction
			new_note.visible = true
			new_note.play_animation("")
			new_note.position.x = get_node("UI/Player Strums/" + NoteFunctions.dir_to_str(new_note.direction)).position.x
			new_note.strum_y = get_node("UI/Player Strums/" + NoteFunctions.dir_to_str(new_note.direction)).global_position.y
			
			if float(note[2]) > 0:
				new_note.is_sustain = true
				new_note.sustain_length = float(note[2])
				new_note.get_node("Line2D").texture = new_note.held_sprites[NoteFunctions.dir_to_str(new_note.direction)][0]
			
			var is_player_note = true
			
			if note[3] and int(note[1]) % (key_count * 2) >= key_count:
				is_player_note = false
			elif !note[3] and int(note[1]) % (key_count * 2) <= key_count - 1:
				is_player_note = false
				
			if is_player_note:
				$"UI/Player Notes".add_child(new_note)
			else:
				$"UI/Enemy Notes".add_child(new_note)
			
			new_note.is_player = is_player_note
			new_note.global_position.y = -5000
			
			noteDataArray.remove(index)
		
		index += 1

var curSection:int = 0

func beat_hit():
	if Conductor.curBeat % 4 == 0 and Settings.get_data("cameraZooms"):
		$Camera2D.zoom = Vector2(defaultCameraZoom - 0.015, defaultCameraZoom - 0.015)
		$UI.scale = Vector2(1.02, 1.02)
		$UI.offset = Vector2(-15, -15)
	
	if bf != null:
		if bf.is_dancing():
			bf.dance()
	if dad != null:
		if dad.is_dancing():
			dad.dance()
	if gf != null:
		if gf.is_dancing():
			gf.dance()
	
	var prevSection = curSection
	
	curSection = floor(Conductor.curStep / 16)
	
	if curSection != prevSection:
		if len(songData["notes"]) - 1 >= curSection:
			if songData["notes"][curSection]["mustHitSection"]:
				$Camera2D.position = stage.get_node("Player Point").position + Vector2(-1 * bf.camOffset.x, bf.camOffset.y)
			else:
				$Camera2D.position = stage.get_node("Dad Point").position + dad.camOffset

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
			gameplay_text.bbcode_text += " | FC"
		elif misses <= 10:
			gameplay_text.bbcode_text += " | SDCB"

var rating_textures = [
	preload("res://Assets/Images/UI/Ratings/marvelous.png"),
	preload("res://Assets/Images/UI/Ratings/sick.png"),
	preload("res://Assets/Images/UI/Ratings/good.png"),
	preload("res://Assets/Images/UI/Ratings/bad.png"),
	preload("res://Assets/Images/UI/Ratings/shit.png")
]

var numbers = [
	preload("res://Assets/Images/UI/Ratings/num0.png"),
	preload("res://Assets/Images/UI/Ratings/num1.png"),
	preload("res://Assets/Images/UI/Ratings/num2.png"),
	preload("res://Assets/Images/UI/Ratings/num3.png"),
	preload("res://Assets/Images/UI/Ratings/num4.png"),
	preload("res://Assets/Images/UI/Ratings/num5.png"),
	preload("res://Assets/Images/UI/Ratings/num6.png"),
	preload("res://Assets/Images/UI/Ratings/num7.png"),
	preload("res://Assets/Images/UI/Ratings/num8.png"),
	preload("res://Assets/Images/UI/Ratings/num9.png")
]

var total_notes:int = 0
var total_hit:float = 0.0

func popup_rating(strum_time):
	var timings = [25, 50, 70, 100]
	var scores = [400, 350, 200, 50, -150]
	
	var ms_dif = strum_time - Conductor.songPosition
	
	var rating = 4
	
	for i in len(timings):
		if abs(ms_dif) <= timings[i]:
			rating = i
			break
	
	$"UI/Ratings".visible = true
	$"UI/Ratings/Rating".texture = rating_textures[rating]
	
	var combo_str = str(combo)
	
	for child in get_node("UI/Ratings/Numbers").get_children():
		child.visible = false
	
	for letter in len(combo_str):
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
	
	if ms_dif == abs(ms_dif):
		$"UI/Ratings/Accuracy Text".set("custom_colors/default_color", Color(0,1,1))
	else:
		$"UI/Ratings/Accuracy Text".set("custom_colors/default_color", Color(1,0.63,0))
	
	match(rating):
		0,1:
			total_hit += 1
			health += 0.035
		2:
			total_hit += 0.8
			health += 0.015
		3:
			total_hit += 0.3
			health += 0.005
		4:
			health -= 0.075
	
	total_notes += 1
	
	update_gameplay_text()
