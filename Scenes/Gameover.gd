extends Node2D

var death_character:Node2D

var funny_timer:Timer

var pressed_enter:bool = false

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
	
	$Camera2D.position = death_character.position + death_character.camOffset
	
	funny_timer = Timer.new()
	funny_timer.set_wait_time(2.375)
	funny_timer.set_one_shot(true)
	add_child(funny_timer)
	funny_timer.start()
	funny_timer.connect("timeout", self, "start_death_stuff")

func start_death_stuff():
	if !pressed_enter:
		death_character.play_animation("deathLoop")
		AudioHandler.play_audio("Gameover Music")
		funny_timer.queue_free()

func _process(_delta):
	if Input.is_action_just_pressed("ui_back"):
		if GameplaySettings.freeplay:
			Scenes.switch_scene("Freeplay")
		else:
			Scenes.switch_scene("Main Menu")
	
	if Input.is_action_just_pressed("ui_accept") and !pressed_enter:
		pressed_enter = true
		
		AudioHandler.stop_audio("Gameover Music")
		AudioHandler.play_audio("Gameover Retry")
		
		death_character.play_animation("retry")
		
		var t = Timer.new()
		t.set_wait_time(1.375)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		
		Scenes.switch_scene("Gameplay")
