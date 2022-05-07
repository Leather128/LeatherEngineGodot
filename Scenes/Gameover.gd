extends Node2D

var death_character:Node2D

var pressed_enter:bool = false

onready var camera = $Camera2D

func _ready():
	AudioHandler.stop_audio("Inst")
	AudioHandler.stop_audio("Voices")
	
	AudioHandler.play_audio("Gameover Death")
	
	var death_loaded = load(Paths.char_path(GameplaySettings.death_character_name))
	
	if death_loaded == null:
		death_loaded = load(Paths.char_path("bf-dead"))
	
	death_character = death_loaded.instance()
	death_character.position = $"Death Point".position
	death_character.play_animation("firstDeath")
	add_child(death_character)
	
	camera.position = death_character.position + death_character.camOffset
	
	get_tree().create_timer(2.375).connect("timeout", self, "start_death_stuff")

func start_death_stuff():
	if !pressed_enter:
		death_character.play_animation("deathLoop")
		AudioHandler.play_audio("Gameover Music")

func _process(_delta):
	if Input.is_action_just_pressed("ui_back"):
		if GameplaySettings.freeplay:
			Scenes.switch_scene("Freeplay")
		else:
			Scenes.switch_scene("Story Mode")
	
	if Input.is_action_just_pressed("ui_accept") and !pressed_enter:
		pressed_enter = true
		
		AudioHandler.stop_audio("Gameover Music")
		AudioHandler.play_audio("Gameover Retry")
		
		death_character.play_animation("retry")
		
		yield(get_tree().create_timer(1.375), "timeout")
		
		Scenes.switch_scene("Gameplay")
