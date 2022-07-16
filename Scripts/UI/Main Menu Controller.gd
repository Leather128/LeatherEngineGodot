extends Node2D

var selected = 0

var selectedAMenu = false
var timeSincePressFunny = 0.0

onready var anim_player = $"../ParallaxBackground/ParallaxLayer/BG/AnimationPlayer"

onready var camera = $"../Camera2D"

func _ready():
	if !AudioHandler.get_node("Title Music").playing:
		AudioHandler.play_audio("Title Music")
	
	change_item(0)

func _process(delta):
	if Input.is_action_just_pressed("ui_back") and !selectedAMenu:
		Scenes.switch_scene("Title Screen")
	if Input.is_action_just_pressed("ui_up") and !selectedAMenu:
		change_item(-1)
	if Input.is_action_just_pressed("ui_down") and !selectedAMenu:
		change_item(1)
	if Input.is_action_just_pressed("ui_accept") and !selectedAMenu:
		selectedAMenu = true
		
		if Settings.get_data("flashingLights"):
			anim_player.play("blinking")
		
		for child in get_children():
			if child != get_children()[selected]:
				child.visible = false
				
		AudioHandler.play_audio("Confirm Sound")
		
	if selectedAMenu:
		if Settings.get_data("flashingLights"):
			timeSincePressFunny += delta
		else:
			timeSincePressFunny = 1.1
	
	if timeSincePressFunny > 1:
		ModLoader.load_specific_mod("")
		
		match(get_children()[selected].name.to_lower()):
			"freeplay":
				Scenes.switch_scene("Freeplay")
			"options":
				Scenes.switch_scene("Options Menu")
			"mods":
				Scenes.switch_scene("Mods Menu")
			"story mode":
				Scenes.switch_scene("Story Mode")
			_:
				print("NOT IMPLEMENTED YET DUMBIE")
		
		timeSincePressFunny = 0
	
func change_item(amount):
	var previousSelected = selected
	
	selected += amount
	
	if selected < 0:
		selected = len(get_children()) - 1
	if selected > len(get_children()) - 1:
		selected = 0
	
	get_children()[previousSelected].get_node("AnimatedSprite").play("unselected")
	get_children()[selected].get_node("AnimatedSprite").play("selected")
	
	AudioHandler.play_audio("Scroll Menu")
	
	if selected != 0:
		camera.position.y = get_children()[selected].position.y - 25
	else:
		camera.position.y = get_children()[selected].position.y
	
	Discord.update_presence("In the Main Menu", "Selecting " + get_children()[selected].name)
