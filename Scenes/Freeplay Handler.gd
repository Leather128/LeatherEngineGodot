extends Node2D

var selected = 0

var selectedASong = false

var songs = []

var difficulties = [
	"easy",
	"normal",
	"hard"
]

var selected_difficulty = 1

var mods = {}

onready var tween = Tween.new()

onready var bg = $"../BG"

func _ready():
	# read the funny directory
	var weeks = [
		"week0",
		"week1",
		"week2",
		"week3",
		"week4",
		"week5",
		"week6",
		"week7",
		"weekTest",
		"weekCuphead",
		"weekAnnie",
		"weekArch",
		"weekMonika",
		"weekTricky",
		"weekBeautifulDay",
		"weekHex",
		"weekShaggyMan",
		"weekFinalDest",
		"weekPVR",
		"weekSoulless6",
		"weekMadVan",
		"weekLore",
		"weekWhitty",
		"wiikVoiid1",
		"weekLullaby",
		"weekBSideCollection",
		"weekHecker"
	]
	
	var mod_weeks: Array = [ ]
	
	for i in len(weeks):
		if mod_weeks.size() - 1 < i:
			mod_weeks.push_back(null)
	
	get_parent().call_deferred("add_child", tween)
	
	for mod_data in ModLoader.mod_instances:
		for week in ModLoader.mod_instances[mod_data].weeks:
			weeks.append(week)
			mod_weeks.append(mod_data)
	
	var ind = 0
	var index = 0
	
	# make freeplay songs
	var template = $Template
	remove_child(template)
	
	for week in weeks:
		ModLoader.load_specific_mod(mod_weeks[ind])
		
		var weekFile = File.new()
		weekFile.open("res://Assets/Weeks/" + week + ".json", File.READ)
		
		var weekSongs = JSON.parse(weekFile.get_as_text()).result["songs"]
		
		for songData in weekSongs:
			mods[str(index)] = mod_weeks[ind]
			
			var song: String = ""
			
			if songData is String:
				song = songData
			else:
				song = songData.song
			
			var newSong = template.duplicate()
			newSong.visible = true
			newSong.text = song.to_upper()
			newSong.name = song.to_lower() + "_" + str(index)
			newSong.rect_size = Vector2(0, 0)
			
			if songData is Dictionary:
				var cool_color: String = songData.color
				
				newSong.freeplay_color = Color(cool_color)
				
				if "ignore_difficulties" in songData:
					newSong.ignore_difficulties = songData.ignore_difficulties
			
			add_child(newSong)
			
			var icon = newSong.get_node("Icon")
			icon.global_position.x = newSong.rect_position.x + newSong.rect_size.x + 100
			
			if songData is Dictionary:
				icon.texture = load("res://Assets/Images/Icons/" + songData.icon + ".png")
				Globals.detect_icon_frames(icon)
			else:
				icon.visible = false
			
			index += 1
			
			songs.append(song)
		
		weekFile.close()
		
		ind += 1
	
	# stop voices and inst if they playing
	AudioHandler.stop_audio("Inst")
	AudioHandler.stop_audio("Voices")
	AudioHandler.stop_audio("Gameover Music")
	
	# play the cool title music
	if !AudioHandler.get_node("Title Music").playing and !Settings.get_data("freeplay_music"):
		AudioHandler.play_audio("Title Music")
	
	Conductor.change_bpm(102)
	
	change_item(0)
	
	tween.stop_all()
	bg.modulate = get_children()[selected].freeplay_color
	
	Conductor.connect("beat_hit", self, "beat_hit")

onready var dif_text = $"../Difficulty"
onready var dif_bg = $"../Dif BG"

var multi_timer: float = 0

var score: int = 0

var cur_score: int = 0

func _physics_process(_delta) -> void:
	cur_score = int(lerp(cur_score, score, 0.4))

func _process(delta: float) -> void:
	if len(difficulties) > 0:
		dif_text.text = "PERSONAL BEST: " + str(cur_score) + "\n<" + difficulties[selected_difficulty].to_upper() + ">\nSpeed: " + str(Globals.song_multiplier)
	
	dif_text.rect_size.x = 0
	dif_text.rect_position.x = 1280 - dif_text.rect_size.x
	
	dif_bg.rect_size.x = dif_text.rect_size.x + 8
	dif_bg.rect_position.x = 1280 - dif_bg.rect_size.x
	
	if !selectedASong:
		if not Input.is_action_pressed("ui_shift"):
			if Input.is_action_just_pressed("ui_left"):
				selected_difficulty += 1
			if Input.is_action_just_pressed("ui_right"):
				selected_difficulty -= 1
			
			if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
				if selected_difficulty > len(difficulties) - 1:
					selected_difficulty = 0
				if selected_difficulty < 0:
					selected_difficulty = len(difficulties) - 1
				
				if len(difficulties) > 0:
					score = Scores.get_song_score(songs[selected].to_lower(), difficulties[selected_difficulty].to_lower())
				
				Discord.update_presence("In the Freeplay Menu", "Selecting: " + songs[selected] + " (" + difficulties[selected_difficulty] + ")")
			else:
				multi_timer = 0
		else:
			if Input.is_action_just_pressed("ui_reset"):
				Globals.song_multiplier = 1
				multi_timer = 0
			
			if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
				multi_timer = 0.11
			
			if Input.is_action_pressed("ui_left") and multi_timer > 0.1:
				multi_timer = 0
				Globals.song_multiplier -= 0.05
			if Input.is_action_pressed("ui_right") and multi_timer > 0.1:
				multi_timer = 0
				Globals.song_multiplier += 0.05
			
			if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				multi_timer += delta
				
				if Globals.song_multiplier < 0.05:
					Globals.song_multiplier = 0.05
			else:
				multi_timer = 0
		
		if Input.is_action_just_pressed("ui_up"):
			change_item(-1, delta)
		if Input.is_action_just_pressed("ui_down"):
			change_item(1, delta)
		
		if Input.is_action_just_pressed("ui_back"):
			AudioHandler.stop_audio("Inst")
			Scenes.switch_scene("Main Menu")
	
	if Input.is_action_just_pressed("ui_accept") and !selectedASong:
		selectedASong = true
		AudioHandler.play_audio("Confirm Sound")
		
		if mods.has(str(selected)):
			ModLoader.load_specific_mod(mods[str(selected)])
		
		Globals.songName = songs[selected]
		
		if len(difficulties) > 0:
			Globals.songDifficulty = difficulties[selected_difficulty].to_lower()
		else:
			Globals.songDifficulty = "hard"
		
		Globals.freeplay = true
		
		var file = File.new()
		file.open(Paths.song_path(Globals.songName, Globals.songDifficulty), File.READ)

		Globals.song = JSON.parse(file.get_as_text()).result["song"]
		
		Scenes.switch_scene("Gameplay")
	
	for i in get_child_count():
		var song: Label = get_child(i)
		
		set_pos_text(song, i - selected, delta)
		
		if song.rect_position.y <= -song.rect_size.y or song.rect_position.y >= 1280 + song.rect_size.y:
			song.visible = false
		else:
			song.visible = true
	
	var cur_icon:Sprite = get_child(selected).get_node("Icon")
	cur_icon.scale = lerp(cur_icon.scale, Vector2(1.0, 1.0), delta * 9.0)
	
	Conductor.songPosition = AudioHandler.get_node("Inst").get_playback_position() * 1000.0

func change_item(amount: int, delta: float = 0.0):
	selected += amount
	
	if selected < 0:
		selected = get_child_count() - 1
	if selected > get_child_count() - 1:
		selected = 0
	
	AudioHandler.play_audio("Scroll Menu")
	
	var selected_child = get_child(selected)
	
	for child in get_children():
		if child != selected_child:
			child.modulate.a = 0.5
			
			child.get_node("Icon").frame = 0
			child.get_node("Icon").scale = Vector2(1, 1)
		else:
			child.modulate.a = 1
			
			if child.get_node("Icon").hframes >= 3:
				child.get_node("Icon").frame = 2
	
	var dir = Directory.new()
	dir.open("res://Assets/Songs/" + songs[selected].to_lower() + "/")
	
	dir.list_dir_begin()
	
	difficulties = []
	
	while true:
		var file = dir.get_next()
		
		if file == "":
			break
		elif file.ends_with(".json"):
			difficulties.append(file.replace(".json", ""))
	
	if difficulties.has("events"):
		difficulties.erase("events")
	
	for difficulty in selected_child.ignore_difficulties:
		if difficulties.has(difficulty):
			difficulties.erase(difficulty)
	
	if selected_difficulty > len(difficulties) - 1:
		selected_difficulty = len(difficulties) - 1
	
	tween.stop_all()
	tween.interpolate_property(bg, "modulate", bg.modulate, get_children()[selected].freeplay_color, 0.5)
	if tween.is_inside_tree():
		tween.start()
	
	if len(difficulties) > 0:
		score = Scores.get_song_score(songs[selected].to_lower(), difficulties[selected_difficulty])
	
	Discord.update_presence("In the Freeplay Menu", "Selecting: " + songs[selected] + " (" + difficulties[selected_difficulty] + ")")
	
	if Settings.get_data("freeplay_music"):
		AudioHandler.get_node("Inst").stream = load("res://Assets/Songs/" + songs[selected].to_lower() + "/Inst.ogg")
		AudioHandler.get_node("Inst").pitch_scale = 1
		AudioHandler.get_node("Inst").volume_db = 0
		AudioHandler.stop_audio("Title Music")
		AudioHandler.play_audio("Inst")
		
		Globals.songName = songs[selected]
		
		if len(difficulties) > 0:
			Globals.songDifficulty = difficulties[selected_difficulty].to_lower()
		else:
			Globals.songDifficulty = "hard"
		
		var file = File.new()
		file.open(Paths.song_path(Globals.songName, Globals.songDifficulty), File.READ)
		
		Conductor.change_bpm(float(JSON.parse(file.get_as_text()).result["song"]["bpm"]))

# goofy
func set_pos_text(text: Control, target_y: int, delta: float):
	var scaled_y = range_lerp(target_y, 0, 1, 0, 1.3)
	var lerp_value = clamp(delta * 9.6, 0.0, 1.0)
	
	# 120 = yMult, 720 = FlxG.height
	text.rect_position.x = lerp(text.rect_position.x, (target_y * 20) + 90, lerp_value)
	text.rect_position.y = lerp(text.rect_position.y, (scaled_y * 120) + (720 * 0.48), lerp_value)

func beat_hit() -> void:
	get_child(selected).get_node("Icon").scale = Vector2(1.2, 1.2)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_WHEEL_DOWN:
			change_item(1)
		elif event.pressed and event.button_index == BUTTON_WHEEL_UP:
			change_item(-1)
