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

var key_count:int = 4

func _ready():
	var file = File.new()
	
	file.open(Paths.song_path(GameplaySettings.songName, GameplaySettings.songDifficulty), File.READ)

	songData = JSON.parse(file.get_as_text()).result["song"]
	
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
	
	$Camera2D.position = stage.get_node("Player Point").position + Vector2(-1 * bf.camOffset.x, bf.camOffset.y)
	
	for section in songData["notes"]:
		for note in section["sectionNotes"]:
			if note[1] != -1:
				noteDataArray.push_back([float(note[0]) + Settings.get_data("offset"), note[1], note[2], bool(section["mustHitSection"])])
	
	AudioHandler.get_node("Inst").stream = load("res://Assets/Songs/" + GameplaySettings.songName.to_lower() + "/Inst.ogg")
	AudioHandler.play_audio("Inst")
	
	if songData["needsVoices"]:
		AudioHandler.get_node("Voices").stream = load("res://Assets/Songs/" + GameplaySettings.songName.to_lower() + "/Voices.ogg")
		AudioHandler.play_audio("Voices")
		AudioHandler.get_node("Voices").seek(0)
	
	AudioHandler.get_node("Inst").seek(0) # cool syncing stuff
	
	GameplaySettings.scroll_speed = float(songData["speed"])
	
	Conductor.songPosition = 0
	Conductor.curBeat = 0
	Conductor.curStep = 0
	Conductor.change_bpm(float(songData["bpm"]))
	Conductor.connect("beat_hit", self, "beat_hit")
	
	var uiNode = $UI
	
	gameplay_text = uiNode.get_node("Gameplay Text")
	
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
		gameplay_text.rect_position.y = 660
	else:
		player_strums.position.y = 75
		enemy_strums.position.y = 75
		gameplay_text.rect_position.y = 95
	
	if Settings.get_data("middlescroll"):
		player_strums.position.x = 470
		align_gameplay_text = ""
		
		enemy_strums.visible = false
		enemy_notes.visible = false
	
	player_notes.position.x = player_strums.position.x
	enemy_notes.position.x = enemy_strums.position.x
	
	player_notes.scale = player_strums.scale
	enemy_notes.scale = enemy_strums.scale

func _physics_process(delta):
	var inst_pos = (AudioHandler.get_node("Inst").get_playback_position() * 1000) + (AudioServer.get_time_since_last_mix() * 1000)
	
	if inst_pos > Conductor.songPosition + 20 or inst_pos < Conductor.songPosition - 20:
		AudioHandler.get_node("Inst").seek(Conductor.songPosition / 1000)
		AudioHandler.get_node("Voices").seek(Conductor.songPosition / 1000)
	
	$Camera2D.zoom = Vector2(lerp(defaultCameraZoom, $Camera2D.zoom.x, 0.95), lerp(defaultCameraZoom, $Camera2D.zoom.y, 0.95))

var align_gameplay_text = "[center]"

func _process(delta):
	gameplay_text.bbcode_text = align_gameplay_text + "Misses: " + str(misses) + " | Combo: " + str(combo)
	
	if Settings.get_data("bot"):
		gameplay_text.bbcode_text += " | BOT"
	else:
		if misses == 0:
			gameplay_text.bbcode_text += " | FC"
		elif misses <= 10:
			gameplay_text.bbcode_text += " | SDCB"
	
	Conductor.songPosition += delta * 1000
	
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
	
	curSection = floor(Conductor.curBeat / 4)
	
	if curSection != prevSection:
		if len(songData["notes"]) - 1 >= curSection:
			if songData["notes"][curSection]["mustHitSection"]:
				$Camera2D.position = stage.get_node("Player Point").position + Vector2(-1 * bf.camOffset.x, bf.camOffset.y)
			else:
				$Camera2D.position = stage.get_node("Dad Point").position + dad.camOffset
