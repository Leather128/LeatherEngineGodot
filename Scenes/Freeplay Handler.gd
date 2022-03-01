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

func _ready():
	# read the funny directory
	var dir = Directory.new()
	dir.open("res://Assets/Weeks/")
	
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		
		if file == "":
			break
		elif not file.begins_with("."):
			var weekFile = File.new()
			weekFile.open("res://Assets/Weeks/" + file, File.READ)
			
			for song in JSON.parse(weekFile.get_as_text()).result["songs"]:
				songs.append(song)
			
			weekFile.close()
	
	# stop voices and inst if they playing
	AudioHandler.stop_audio("Inst")
	AudioHandler.stop_audio("Voices")
	
	# play the cool title music
	if !AudioHandler.get_node("Title Music").playing:
		AudioHandler.play_audio("Title Music")
	
	Conductor.change_bpm(102)
	
	# make freeplay songs
	var template = $Template
	remove_child(template)
	
	var index = 0
	
	for song in songs:
		var newSong = template.duplicate()
		newSong.visible = true
		newSong.text = song.to_upper()
		newSong.name = song.to_lower() + "_" + str(index)
		newSong.rect_position.y = 38 + (113 * index)
		add_child(newSong)
		
		index += 1
		
	change_item(0)

func _process(_delta):
	$"../CanvasLayer/Difficulty".bbcode_text = "[right]<" + difficulties[selected_difficulty].to_upper() + ">"
	
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
		
		GameplaySettings.songName = songs[selected]
		GameplaySettings.songDifficulty = difficulties[selected_difficulty].to_lower()
		GameplaySettings.freeplay = true
		
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
