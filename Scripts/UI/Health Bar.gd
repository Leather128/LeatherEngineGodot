extends Node2D

onready var iconP1 = $Player
onready var iconP2 = $Opponent

onready var barBG = $Bar/Sprite
onready var bar = $Bar/ProgressBar

onready var game = $"../../"

func _ready():
	Conductor.connect("beat_hit", self, "beat_hit")

func _physics_process(_delta):
	iconP1.scale.x = lerp(iconP1.scale.x, 1, 0.09)
	iconP2.scale.x = lerp(iconP2.scale.x, 1, 0.09)
	
	iconP1.scale.y = lerp(iconP1.scale.y, 1, 0.09)
	iconP2.scale.y = lerp(iconP2.scale.y, 1, 0.09)

func _process(_delta):
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
		GameplaySettings.death_character_name = game.bf.death_character
		Scenes.switch_scene("Gameover")
		

var icon_beat_scale = 0.2

func beat_hit():
	iconP1.scale.x += icon_beat_scale
	iconP2.scale.x += icon_beat_scale
	
	if iconP1.scale.x > 1 + icon_beat_scale:
		iconP1.scale.x = 1 + icon_beat_scale
	if iconP2.scale.x > 1 + icon_beat_scale:
		iconP2.scale.x = 1 + icon_beat_scale
	
	iconP1.scale.y += icon_beat_scale
	iconP2.scale.y += icon_beat_scale
	
	if iconP1.scale.y > 1 + icon_beat_scale:
		iconP1.scale.y = 1 + icon_beat_scale
	if iconP2.scale.y > 1 + icon_beat_scale:
		iconP2.scale.y = 1 + icon_beat_scale
