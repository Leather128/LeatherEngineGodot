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

onready var bg = $"../CanvasLayer/BG"

func _ready():
	# read the funny directory
	var weeks = [
		"week0",
		"week1",
		"week2",
		"week3",
		"week4",
		"week6",
		"week7",
		"weekTest"
	]
	
	var mod_weeks = [
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null
	]
	
	$"../CanvasLayer".add_child(tween)
	
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
			newSong.rect_position.x = 37 + (30 * index)
			newSong.rect_position.y = 38 + (150 * index)
			newSong.rect_size = Vector2(0, 0)
			
			if songData is Dictionary:
				var cool_color: String = songData.color
				
				newSong.freeplay_color = Color(cool_color)
			
			add_child(newSong)
			
			var icon = newSong.get_node("Icon")
			icon.global_position.x = newSong.rect_position.x + newSong.rect_size.x + 100
			
			if songData is Dictionary:
				icon.texture = load("res://Assets/Images/Icons/" + songData.icon + ".png")
				
				if icon.texture.get_width() <= 300:
					icon.hframes = 2
				elif icon.texture.get_width() <= 150:
					icon.hframes = 1
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
	if !AudioHandler.get_node("Title Music").playing:
		AudioHandler.play_audio("Title Music")
	
	Conductor.change_bpm(102)
		
	change_item(0)
	
	tween.stop_all()
	bg.modulate = get_children()[selected].freeplay_color

onready var dif_text = $"../CanvasLayer/Difficulty"
onready var dif_bg = $"../CanvasLayer/Dif BG"

var multi_timer: float = 0

var score: int = 0

func _process(delta):
	dif_text.text = "PERSONAL BEST: " + str(score) + "\n<" + difficulties[selected_difficulty].to_upper() + ">\nSpeed: " + str(GameplaySettings.song_multiplier)
	
	dif_text.rect_size.x = 0
	dif_text.rect_position.x = 1280 - dif_text.rect_size.x
	
	dif_bg.rect_size.x = dif_text.rect_size.x + 4
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
				
				score = Scores.get_song_score(songs[selected].to_lower(), difficulties[selected_difficulty].to_lower())
			else:
				multi_timer = 0
		else:
			if Input.is_action_just_pressed("ui_reset"):
				GameplaySettings.song_multiplier = 1
				multi_timer = 0
			
			if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
				multi_timer = 0.11
			
			if Input.is_action_pressed("ui_left") and multi_timer > 0.1:
				multi_timer = 0
				GameplaySettings.song_multiplier -= 0.05
			if Input.is_action_pressed("ui_right") and multi_timer > 0.1:
				multi_timer = 0
				GameplaySettings.song_multiplier += 0.05
			
			if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				multi_timer += delta
				
				if GameplaySettings.song_multiplier < 0.05:
					GameplaySettings.song_multiplier = 0.05
			else:
				multi_timer = 0
		
		if Input.is_action_just_pressed("ui_up"):
			change_item(-1)
		if Input.is_action_just_pressed("ui_down"):
			change_item(1)
		
		if Input.is_action_just_pressed("ui_back"):
			Scenes.switch_scene("Main Menu")
	
	if Input.is_action_just_pressed("ui_accept") and !selectedASong:
		selectedASong = true
		AudioHandler.play_audio("Confirm Sound")
		
		if mods.has(str(selected)):
			ModLoader.load_specific_mod(mods[str(selected)])
		
		GameplaySettings.songName = songs[selected]
		GameplaySettings.songDifficulty = difficulties[selected_difficulty].to_lower()
		GameplaySettings.freeplay = true
		
		var file = File.new()
		file.open(Paths.song_path(GameplaySettings.songName, GameplaySettings.songDifficulty), File.READ)

		GameplaySettings.song = JSON.parse(file.get_as_text()).result["song"]
		
		Scenes.switch_scene("Gameplay")

func change_item(amount):
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
		else:
			child.modulate.a = 1
			
			child.get_node("Icon").frame = 2
	
	$"../Camera2D".position.x = 640 + selected_child.rect_position.x - 75
	$"../Camera2D".position.y = selected_child.rect_position.y
	
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
	
	if selected_difficulty > len(difficulties) - 1:
		selected_difficulty = len(difficulties) - 1
	
	tween.stop_all()
	tween.interpolate_property(bg, "modulate", bg.modulate, get_children()[selected].freeplay_color, 0.5)
	tween.start()
	
	score = Scores.get_song_score(songs[selected].to_lower(), difficulties[selected_difficulty])
