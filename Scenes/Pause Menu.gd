extends Control

var selected = 0
var showing = false

func _ready():
	hide()

func _process(delta):
	if Input.is_action_just_pressed("ui_confirm") and Scenes.current_scene == "Gameplay" and !showing:
		get_tree().paused = !get_tree().paused
		
		if get_tree().paused:
			selected = 0
			show()
			on_show()
			showing = true
			refresh_bullshit()
			
			AudioHandler.get_node("Inst").stream_paused = true
			AudioHandler.get_node("Voices").stream_paused = true
		else:
			hide()
			showing = false
			
			AudioHandler.get_node("Inst").stream_paused = false
			AudioHandler.get_node("Voices").stream_paused = false
	elif Input.is_action_just_pressed("ui_confirm") and Scenes.current_scene == "Gameplay" and showing:
		get_tree().paused = false
		hide()
		showing = false
		AudioHandler.get_node("Inst").stream_paused = false
		AudioHandler.get_node("Voices").stream_paused = false
		
		match(selected):
			1:
				Scenes.switch_scene("Gameplay")
			2:
				if GameplaySettings.freeplay:
					Scenes.switch_scene("Freeplay")
				else:
					Scenes.switch_scene("Story Mode")
	
	if showing:
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
	$"Song Info".text = GameplaySettings.song.song + "\n" + GameplaySettings.songDifficulty.to_upper()

func refresh_bullshit():
	$Resume.modulate.a = 0.5
	$"Restart Song".modulate.a = 0.5
	$"Exit Menu".modulate.a = 0.5
	
	match(selected):
		0:
			$Resume.modulate.a = 1
		1:
			$"Restart Song".modulate.a = 1
		2:
			$"Exit Menu".modulate.a = 1
