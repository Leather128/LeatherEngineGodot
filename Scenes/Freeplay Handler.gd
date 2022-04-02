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
		"week7",
		"weekBob",
		"weekCustom",
		"weekshaggy",
		"weekTechno1",
		"weekTechno1Classic",
		"weekTechno2",
		"weekTechnoExtras",
		"weekWindow"
	]
	
	var mod_weeks = [
		null,
		null,
		null,
		null,
		null,
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
			newSong.rect_position.y = 38 + (113 * index)
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

func _process(_delta):
	dif_text.text = "<" + difficulties[selected_difficulty].to_upper() + ">"
	
	var font = dif_text.get_font("font")
	
	dif_bg.rect_size.x = font.get_string_size(dif_text.text).x + 4
	dif_bg.rect_position.x = 1280 - dif_bg.rect_size.x
	
	if !selectedASong:
		if Input.is_action_just_pressed("ui_left"):
			selected_difficulty += 1
		if Input.is_action_just_pressed("ui_right"):
			selected_difficulty -= 1
		
		if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
			if selected_difficulty > len(difficulties) - 1:
				selected_difficulty = 0
			if selected_difficulty < 0:
				selected_difficulty = len(difficulties) - 1
		
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
		selected = len(get_children()) - 1
	if selected > len(get_children()) - 1:
		selected = 0
	
	AudioHandler.play_audio("Scroll Menu")
	
	for child in get_children():
		if child != get_children()[selected]:
			child.modulate.a = 0.5
		else:
			child.modulate.a = 1
	
	$"../Camera2D".position.y = get_children()[selected].rect_position.y
	
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
	
	Presence.update("Freeplay", "Selected: " + songs[selected].to_upper())
