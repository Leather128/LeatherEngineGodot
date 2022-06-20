extends Node2D

onready var iconP1 = $Player
onready var iconP2 = $Opponent

onready var barBG = $Bar/Sprite
onready var bar = $Bar/ProgressBar

onready var game = $"../../"

onready var bounce_type: String = Settings.get_data("health_icon_bounce")

var icon_bounce: IconBounce

func _ready():
	var file = File.new()
	
	if file.file_exists("res://Scripts/UI/Icons/" + bounce_type + ".gd") or file.file_exists("res://Scripts/UI/Icons/" + bounce_type + ".gdc"):
		if file.file_exists("res://Scripts/UI/Icons/" + bounce_type + ".gdc"):
			icon_bounce = load("res://Scripts/UI/Icons/" + bounce_type + ".gdc").new()
		else:
			icon_bounce = load("res://Scripts/UI/Icons/" + bounce_type + ".gd").new()
	else:
		if file.file_exists("res://Scripts/UI/Icons/default.gdc"):
			icon_bounce = load("res://Scripts/UI/Icons/default.gdc").new()
		else:
			icon_bounce = load("res://Scripts/UI/Icons/default.gd").new()
	
	add_child(icon_bounce)
	
	icon_bounce.iconP1 = iconP1
	icon_bounce.iconP2 = iconP2
	
	if not icon_bounce.runs_on_step:
		Conductor.connect("beat_hit", icon_bounce, "beat_hit")
	else:
		Conductor.connect("step_hit", icon_bounce, "beat_hit")

func _process(delta):
	icon_bounce.health = game.health
	
	icon_bounce.on_process(delta)
	
	bar.value = game.health
	game.health = bar.value
	
	var redone_percent = range_lerp(game.health, 0, 2, 100, 0) / 100
	
	iconP1.global_position.x = bar.rect_position.x + ((592 * redone_percent) - 150) - (150 / 3)
	iconP2.global_position.x = bar.rect_position.x + ((592 * redone_percent) - 150) - (150 * 1.1)
	
	if redone_percent <= 0.2:
		if iconP1.hframes >= 3:
			iconP1.frame = 2
		
		if iconP2.hframes >= 2:
			iconP2.frame = 1
	else:
		iconP1.frame = 0
		iconP2.frame = 0
	
	if redone_percent >= 0.8:
		if iconP1.hframes >= 2:
			iconP1.frame = 1
		
		if iconP2.hframes >= 3:
			iconP2.frame = 2
	
	if redone_percent >= 1:
		if game.bf:
			GameplaySettings.death_character_name = game.bf.death_character
		
		GameplaySettings.death_character_pos = game.bf.position
		GameplaySettings.death_character_cam = game.camera.position
		
		Scenes.switch_scene("Gameover", true)
