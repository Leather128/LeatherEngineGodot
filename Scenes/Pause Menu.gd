extends Control

var selected = 0
var showing = false

onready var tween = $Tween

onready var bg = $BG

onready var resume = $Resume
onready var restart_song = $"Restart Song"
onready var exit_menu = $"Exit Menu"

onready var song_name = $"Song Name"
onready var song_difficulty = $"Song Difficulty"

func _ready():
	hide()

func _process(delta):
	if Input.is_action_just_pressed("ui_confirm") and Scenes.current_scene == "Gameplay" and !showing:
		get_tree().paused = true
		
		tween.stop_all()
		
		resume.rect_position = Vector2(70, 200)
		restart_song.rect_position = Vector2(70, 200)
		exit_menu.rect_position = Vector2(70, 200)
		
		bg.modulate.a = 0
		tween.interpolate_property(bg, "modulate", Color(1,1,1,0), Color(1,1,1,0.9), 0.4, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
		
		song_name.modulate.a = 0
		song_difficulty.modulate.a = 0
		
		song_name.rect_position.y = 10
		song_difficulty.rect_position.y = 40 # 10 + 30
		
		tween.interpolate_property(song_name, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.4, Tween.TRANS_QUART, Tween.EASE_IN_OUT, 0.3)
		tween.interpolate_property(song_name, "rect_position:y", 10, 15, 0.4, Tween.TRANS_QUART, Tween.EASE_IN_OUT, 0.3)
		
		tween.interpolate_property(song_difficulty, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.4, Tween.TRANS_QUART, Tween.EASE_IN_OUT, 0.5)
		tween.interpolate_property(song_difficulty, "rect_position:y", 40, 45, 0.4, Tween.TRANS_QUART, Tween.EASE_IN_OUT, 0.5)
		
		tween.start()
		
		selected = 0
		show()
		on_show()
		showing = true
		refresh_bullshit()
		
		song_name.rect_position.x = 1280 - (song_name.rect_size.x + 20)
		song_difficulty.rect_position.x = 1280 - (song_difficulty.rect_size.x + 20)
		
		AudioHandler.get_node("Inst").stream_paused = true
		AudioHandler.get_node("Voices").stream_paused = true
	elif Input.is_action_just_pressed("ui_confirm") and Scenes.current_scene == "Gameplay" and showing:
		get_tree().paused = false
		hide()
		showing = false
		AudioHandler.get_node("Inst").stream_paused = false
		AudioHandler.get_node("Voices").stream_paused = false
		
		match(selected):
			1:
				Scenes.switch_scene("Gameplay")
				GameplaySettings.do_cutscenes = false
			2:
				if GameplaySettings.freeplay:
					Scenes.switch_scene("Freeplay")
				else:
					Scenes.switch_scene("Story Mode")
	
	if showing:
		set_pos_text(resume, 0 - selected, delta)
		set_pos_text(restart_song, 1 - selected, delta)
		set_pos_text(exit_menu, 2 - selected, delta)
		
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
			if Input.is_action_just_pressed("ui_down"):
				selected += 1
			if Input.is_action_just_pressed("ui_up"):
				selected -= 1
			
			if selected > 2:
				selected = 0
			if selected < 0:
				selected = 2
			
			AudioHandler.play_audio("Scroll Menu")
			
			refresh_bullshit()

func on_show():
	song_name.text = GameplaySettings.song.song
	song_difficulty.text = GameplaySettings.songDifficulty.to_upper()

func refresh_bullshit():
	resume.modulate.a = 0.5
	restart_song.modulate.a = 0.5
	exit_menu.modulate.a = 0.5
	
	match(selected):
		0:
			resume.modulate.a = 1
		1:
			restart_song.modulate.a = 1
		2:
			exit_menu.modulate.a = 1

func set_pos_text(text, targetY, elapsed):
	var scaledY = range_lerp(targetY, 0, 1, 0, 1.3)
	
	var lerpVal = clamp(elapsed * 9.6, 0.0, 1.0)
	
	# 120 = yMult, 720 = FlxG.height
	text.rect_position.y = lerp(text.rect_position.y, (scaledY * 120) + (720 * 0.48), lerpVal);

	text.rect_position.x = lerp(text.rect_position.x, (targetY * 20) + 90, lerpVal)
