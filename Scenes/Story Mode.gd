extends Node2D

onready var week_template = $"Weeks/Week Template"
onready var weeks_node = $Weeks

onready var week_name = $"Main UI/Week Name"

onready var week_score = $"Main UI/Week Score"

onready var left_arrow = $"Main UI/Left Arrow"
onready var right_arrow = $"Main UI/Right Arrow"
onready var difficulty_sprite = $"Main UI/Difficulty"

onready var dad = $"Main UI/Characters/dad"
onready var bf = $"Main UI/Characters/bf"
onready var gf = $"Main UI/Characters/gf"

onready var bg = $"Main UI/Yellow Thingy"

var selected: int = 0

var selected_difficulty: int = 1
var difficulties: Array = ["easy", "normal", "hard"]

var weeks = [
	"week0",
	"week1",
	"week2",
	"week3",
	"week4",
	"week5",
	"week6",
	"week7",
	"weekTest"
]

onready var tween = Tween.new()
onready var icon = $"Main UI/Icons/Icon"

func _ready():
	add_child(tween)
	
	if !AudioHandler.get_node("Title Music").playing:
		AudioHandler.play_audio("Title Music")
		
	AudioHandler.stop_audio("Inst")
	AudioHandler.stop_audio("Voices")
	AudioHandler.stop_audio("Gameover Music")
	
	for mod_data in ModLoader.mod_instances:
		for week in ModLoader.mod_instances[mod_data].weeks:
			weeks.append(week)
	
	var file = File.new()
	
	for week in weeks:
		file.open("res://Assets/Weeks/" + week + ".json", File.READ)
		
		var data = JSON.parse(file.get_as_text()).result
		
		if "hide_from_story_mode" in data:
			if !data.hide_from_story_mode:
				var new_week = week_template.duplicate()
				new_week.name = week
				
				var sprite = new_week.get_node("Sprite")
				sprite.texture = load("res://Assets/Images/UI/Story Mode/Weeks/" + week + ".png")
				
				if sprite.texture == null:
					sprite.texture = load("res://icon.png")
				
				new_week.get_node("Lock").visible = false
				
				if weeks_node.get_child_count() > 1:
					new_week.position.y = weeks_node.get_children()[weeks_node.get_child_count() - 1].position.y + 120
				
				new_week.visible = true
				
				new_week.week_name = week
				
				var songs = []
				
				for song in data.songs:
					if song is Dictionary:
						if song.story:
							songs.append([song.song, song.icon])
					else:
						songs.append([song, "placeholder-icon"])
				
				new_week.songs = songs
				
				if "difficulties" in data:
					new_week.difficulties = data.difficulties
				else:
					new_week.difficulties = ["easy", "normal", "hard"]
				
				if "chars" in data:
					new_week.characters = data.chars
				else:
					new_week.characters = ["dad", "bf", "gf"]
				
				if "week_name" in data:
					new_week.week_text = data.week_name
				else:
					new_week.week_text = ""
				
				if "story_color" in data:
					new_week.color = Color(data.story_color)
				
				if len(songs) > 0:
					weeks_node.add_child(new_week)
				else:
					new_week.queue_free()
		
		file.close()
	
	weeks_node.remove_child(week_template)
	week_template.free()
	
	update_selection()

func _process(_delta):
	if Input.is_action_just_pressed("ui_back"):
		Scenes.switch_scene("Main Menu")
	
	if Input.is_action_just_pressed("ui_down"):
		update_selection(1)
	if Input.is_action_just_pressed("ui_up"):
		update_selection(-1)
	
	if Input.is_action_just_pressed("ui_left"):
		change_difficulty(-1)
	if Input.is_action_just_pressed("ui_right"):
		change_difficulty(1)
	
	if Input.is_action_pressed("ui_left"):
		left_arrow.play("arrow push")
	else:
		left_arrow.play("arrow")
	if Input.is_action_pressed("ui_right"):
		right_arrow.play("arrow push")
	else:
		right_arrow.play("arrow")
	
	if Input.is_action_just_pressed("ui_accept"):
		GameplaySettings.songName = weeks_node.get_children()[selected].songs[0][0]
		GameplaySettings.songDifficulty = difficulties[selected_difficulty].to_lower()
		GameplaySettings.freeplay = false
		GameplaySettings.weekSongs = weeks_node.get_children()[selected].songs
		GameplaySettings.weekSongs.erase(GameplaySettings.songName)
		
		var file = File.new()
		file.open(Paths.song_path(GameplaySettings.songName, GameplaySettings.songDifficulty), File.READ)

		if file.get_as_text() != null:
			GameplaySettings.song = JSON.parse(file.get_as_text()).result["song"]
			
			Scenes.switch_scene("Gameplay")
			
			AudioHandler.play_audio("Confirm Sound")

onready var camera = $Camera2D
onready var track_text = $"Main UI/Tracks"
onready var characters = $"Main UI/Characters"

func update_selection(amount = 0):
	selected += amount
	
	if selected < 0:
		selected = weeks_node.get_child_count() - 1
	if selected > weeks_node.get_child_count() - 1:
		selected = 0
	
	AudioHandler.play_audio("Scroll Menu")
	
	var selected_week = weeks_node.get_children()[selected]
	
	# 507 (template value) - 360 (screen height / 2) = 147 (offset of camera)
	camera.position.y = selected_week.global_position.y - 165
	
	for week in weeks_node.get_children():
		if week != selected_week:
			week.modulate.a = 0.6
		else:
			week.modulate.a = 1
	
	track_text.text = "Tracks\n\n"
	
	for song in selected_week.songs:
		track_text.text += song[0].to_upper() + "\n"
	
	if Settings.get_data("story_mode_icons"):
		icon.visible = true
		icon.texture = load("res://Assets/Images/Icons/" + selected_week.songs[0][1] + ".png")
		
		if icon.texture.get_width() >= 450:
			icon.hframes = 3
		elif icon.texture.get_width() >= 300:
			icon.hframes = 2
		else:
			icon.hframes = 1
	else:
		icon.visible = false
		icon.texture = null
	
	var dad_load = load("res://Scenes/Story Mode Characters/" + selected_week.characters[0] + ".tscn")
	var bf_load = load("res://Scenes/Story Mode Characters/" + selected_week.characters[1] + ".tscn")
	var gf_load = load("res://Scenes/Story Mode Characters/" + selected_week.characters[2] + ".tscn")
	
	if dad_load != null and dad.name != selected_week.characters[0]:
		dad.queue_free()
	else:
		dad_load = null
	if bf_load != null and bf.name != selected_week.characters[1]:
		bf.queue_free()
	else:
		bf_load = null
	if gf_load != null and gf.name != selected_week.characters[2]:
		gf.queue_free()
	else:
		gf_load = null
	
	var old_dad = dad
	var old_bf = bf
	var old_gf = gf
	
	if dad_load != null:
		dad = dad_load.instance()
	if bf_load != null:
		bf = bf_load.instance()
	if gf_load != null:
		gf = gf_load.instance()
	
	dad.position = old_dad.position
	bf.position = old_bf.position
	gf.position = old_gf.position
	
	if dad_load != null:
		characters.add_child(dad)
	if bf_load != null:
		characters.add_child(bf)
	if gf_load != null:
		characters.add_child(gf)
	
	week_name.text = selected_week.week_text
	
	difficulties = selected_week.difficulties
	
	bg.color = selected_week.color
	
	change_difficulty()

func change_difficulty(change: int = 0):
	selected_difficulty += change
	
	if selected_difficulty < 0:
		selected_difficulty = len(difficulties) - 1
	if selected_difficulty > len(difficulties) - 1:
		selected_difficulty = 0
	
	var texture = load("res://Assets/Images/UI/Story Mode/Difficulties/" + difficulties[selected_difficulty].to_lower() + ".png")
	
	if texture == null:
		texture = load("res://icon.png")
	
	difficulty_sprite.texture = texture
	
	tween.interpolate_property(difficulty_sprite, "position:y", 492, 505, 0.1)
	tween.stop_all()
	tween.start()
	
	var week_score_data = 0
	
	for song in weeks_node.get_children()[selected].songs:
		week_score_data += Scores.get_song_score(song[0].to_lower(), difficulties[selected_difficulty].to_lower())
	
	week_score.text = "SCORE: " + str(week_score_data)
	
	Discord.update_presence("In the Story Menu", "Selecting " + weeks_node.get_children()[selected].name + " (" + difficulties[selected_difficulty] + ")")
