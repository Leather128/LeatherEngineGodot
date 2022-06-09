extends Node2D

onready var iconP1 = $Player
onready var iconP2 = $Opponent

onready var barBG = $Bar/Sprite
onready var bar = $Bar/ProgressBar

onready var game = $"../../"

onready var bounce_type: String = Settings.get_data("health_icon_bounce")

func _ready():
	if bounce_type != "on step":
		Conductor.connect("beat_hit", self, "beat_hit")
	else:
		Conductor.connect("step_hit", self, "beat_hit")

func _physics_process(_delta):
	match(bounce_type):
		"on step":
			iconP1.scale.x = lerp(iconP1.scale.x, 1, 0.36)
			iconP2.scale.x = lerp(iconP2.scale.x, 1, 0.36)
			
			iconP1.scale.y = lerp(iconP1.scale.y, 1, 0.36)
			iconP2.scale.y = lerp(iconP2.scale.y, 1, 0.36)
			
			iconP1.offset.x = lerp(iconP1.offset.x, 0, 0.36)
			iconP1.offset.y = lerp(iconP1.offset.y, 0, 0.36)
			
			iconP2.offset.x = lerp(iconP2.offset.x, 0, 0.36)
			iconP2.offset.y = lerp(iconP2.offset.y, 0, 0.36)
		"inverted":
			iconP1.scale.x = lerp(iconP1.scale.x, -1, 0.15)
			iconP2.scale.x = lerp(iconP2.scale.x, -1, 0.15)
			
			iconP1.scale.y = lerp(iconP1.scale.y, -1, 0.15)
			iconP2.scale.y = lerp(iconP2.scale.y, -1, 0.15)
			
			iconP1.offset.x = lerp(iconP1.offset.x, 0, 0.15)
			iconP1.offset.y = lerp(iconP1.offset.y, 0, 0.15)
			
			iconP2.offset.x = lerp(iconP2.offset.x, 0, 0.15)
			iconP2.offset.y = lerp(iconP2.offset.y, 0, 0.15)
		"default":
			iconP1.scale.x = lerp(iconP1.scale.x, 1, 0.15)
			iconP2.scale.x = lerp(iconP2.scale.x, 1, 0.15)
			
			iconP1.scale.y = lerp(iconP1.scale.y, 1, 0.15)
			iconP2.scale.y = lerp(iconP2.scale.y, 1, 0.15)
			
			iconP1.offset.x = lerp(iconP1.offset.x, 0, 0.15)
			iconP1.offset.y = lerp(iconP1.offset.y, 0, 0.15)
			
			iconP2.offset.x = lerp(iconP2.offset.x, 0, 0.15)
			iconP2.offset.y = lerp(iconP2.offset.y, 0, 0.15)
		"by bpm":
			iconP1.scale.x = lerp(iconP1.scale.x, 1, 0.09 * (Conductor.bpm / 120.0))
			iconP2.scale.x = lerp(iconP2.scale.x, 1, 0.09 * (Conductor.bpm / 120.0))
			
			iconP1.scale.y = lerp(iconP1.scale.y, 1, 0.09 * (Conductor.bpm / 120.0))
			iconP2.scale.y = lerp(iconP2.scale.y, 1, 0.09 * (Conductor.bpm / 120.0))
			
			iconP1.offset.x = lerp(iconP1.offset.x, 0, 0.09 * (Conductor.bpm / 120.0))
			iconP1.offset.y = lerp(iconP1.offset.y, 0, 0.09 * (Conductor.bpm / 120.0))
			
			iconP2.offset.x = lerp(iconP2.offset.x, 0, 0.09 * (Conductor.bpm / 120.0))
			iconP2.offset.y = lerp(iconP2.offset.y, 0, 0.09 * (Conductor.bpm / 120.0))
		_:
			iconP1.scale.x = lerp(iconP1.scale.x, 1, 0.09)
			iconP2.scale.x = lerp(iconP2.scale.x, 1, 0.09)
			
			iconP1.scale.y = lerp(iconP1.scale.y, 1, 0.09)
			iconP2.scale.y = lerp(iconP2.scale.y, 1, 0.09)
			
			iconP1.offset.x = lerp(iconP1.offset.x, 0, 0.09)
			iconP1.offset.y = lerp(iconP1.offset.y, 0, 0.09)
			
			iconP2.offset.x = lerp(iconP2.offset.x, 0, 0.09)
			iconP2.offset.y = lerp(iconP2.offset.y, 0, 0.09)
	
	if bounce_type == "twist":
		iconP1.rotation_degrees = lerp(iconP1.rotation_degrees, 0, 0.09)
		iconP2.rotation_degrees = lerp(iconP2.rotation_degrees, 0, 0.09)
	
	if bounce_type == "spin":
		iconP1.rotation_degrees += 1.5 * game.health
		iconP2.rotation_degrees -= 1.5 * game.health

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
		if game.bf:
			GameplaySettings.death_character_name = game.bf.death_character
		
		Scenes.switch_scene("Gameover", true)

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
	
	match(bounce_type):
		"psych":
			iconP1.offset.x = ((150 * iconP1.scale.x) - 150) / 2
			iconP2.offset.x = (-((150 * iconP2.scale.x) - 150)) / 2
			
			iconP1.offset.x = lerp(iconP1.offset.x, 0, 0.09)
			iconP1.offset.y = lerp(iconP1.offset.y, 0, 0.09)
			
			iconP2.offset.x = lerp(iconP2.offset.x, 0, 0.09)
			iconP2.offset.y = lerp(iconP2.offset.y, 0, 0.09)
		"centered":
			pass
		_:
			iconP1.offset.x = 10
			iconP1.offset.y = 10
			
			iconP2.offset.x = -10
			iconP2.offset.y = 10
			
			iconP1.offset.x = lerp(iconP1.offset.x, 0, 0.09)
			iconP1.offset.y = lerp(iconP1.offset.y, 0, 0.09)
			
			iconP2.offset.x = lerp(iconP2.offset.x, 0, 0.09)
			iconP2.offset.y = lerp(iconP2.offset.y, 0, 0.09)
	
	# stupid effects switch
	match(bounce_type):
		"twist":
			twist = not twist
			
			if twist:
				iconP1.rotation_degrees = 15
				
				iconP1.scale.y -= icon_beat_scale
				iconP1.scale.x += icon_beat_scale
			else:
				iconP1.rotation_degrees = -15
				
				iconP1.scale.y += icon_beat_scale
				iconP1.scale.x -= icon_beat_scale
			
			if twist:
				iconP2.rotation_degrees = -15
				
				iconP2.scale.y += icon_beat_scale
				iconP2.scale.x -= icon_beat_scale
			else:
				iconP2.rotation_degrees = 15
				
				iconP2.scale.y -= icon_beat_scale
				iconP2.scale.x += icon_beat_scale
		"wide":
			iconP1.scale.x += icon_beat_scale * 2
			iconP1.scale.y -= icon_beat_scale * 1.5
			
			iconP2.scale.x += icon_beat_scale * 2
			iconP2.scale.y -= icon_beat_scale * 1.5
		"inverted":
			if iconP1.scale.x > 0:
				iconP1.scale -= Vector2(icon_beat_scale, icon_beat_scale)
				iconP2.scale -= Vector2(icon_beat_scale, icon_beat_scale)

# stupid effects variables
var twist = false
