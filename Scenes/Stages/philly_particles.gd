extends Node2D

onready var sky = $"../../Far BG/Sky"
onready var city = $"../../BG/City"

onready var behind_train = $"../Behind Train"
onready var train = $"../Train"
onready var street = $"../Street"

onready var part1 = $Particle1
onready var part2 = $Particle2
onready var part3 = $Particle3

onready var stage = $"../../../"
onready var game = stage.get_node("../")

onready var blammed_shader = load("res://Assets/Shaders/Blammed Character Shader.tres")

onready var player_icon = game.get_node("UI/Health Bar/Player")
onready var enemy_icon = game.get_node("UI/Health Bar/Opponent")

onready var bar = game.get_node("UI/Health Bar/Bar/ProgressBar")
onready var bar_outline = game.get_node("UI/Health Bar/Bar/Sprite")

onready var progress_bar_outline = game.get_node("UI/Progress Bar/Sprite")

var tween = Tween.new()

# created for blammed lol
func _ready() -> void:
	if Globals.songName.to_lower() != "blammed":
		queue_free()
	else:
		set_particles_emitting(false)
		visible = false
		
		Conductor.connect("beat_hit", self, "beat_hit")
		
		$"../".call_deferred("add_child", tween)
		
		if "anim_sprite" in game.bf:
			game.bf.get_node("AnimatedSprite").material = blammed_shader
		if "anim_sprite" in game.gf:
			game.gf.get_node("AnimatedSprite").material = blammed_shader
		if "anim_sprite" in game.dad:
			game.dad.get_node("AnimatedSprite").material = blammed_shader
		
		player_icon.material = blammed_shader
		enemy_icon.material = blammed_shader
		bar_outline.material = blammed_shader
		progress_bar_outline.material = blammed_shader
		train.material = blammed_shader

func beat_hit():
	var cur_beat = Conductor.curBeat
	
	if cur_beat >= 192:
		var tween_time:float = (Conductor.timeBetweenBeats / Globals.song_multiplier) / 1000.0
		
		sky.modulate.a = 0
		city.modulate.a = 0
		behind_train.modulate.a = 0
		street.modulate.a = 0
		
		tween.interpolate_property(sky, "modulate", Color(1,1,1,0), Color(1,1,1,1), tween_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(city, "modulate", Color(1,1,1,0), Color(1,1,1,1), tween_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(behind_train, "modulate", Color(1,1,1,0), Color(1,1,1,1), tween_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(street, "modulate", Color(1,1,1,0), Color(1,1,1,1), tween_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween.interpolate_property(game.gf, "modulate", Color(1,1,1,0), Color(1,1,1,1), tween_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(game.bf, "modulate", game.bf.modulate, Color(1,1,1,1), tween_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(game.dad, "modulate", game.dad.modulate, Color(1,1,1,1), tween_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween.interpolate_property(player_icon, "modulate", player_icon.modulate, Color(1,1,1,1), tween_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(enemy_icon, "modulate", enemy_icon.modulate, Color(1,1,1,1), tween_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(bar_outline, "modulate", bar_outline.modulate, Color(1,1,1,1), tween_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween.interpolate_property(progress_bar_outline, "modulate", progress_bar_outline.modulate, Color(1,1,1,1), tween_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween.interpolate_property(train, "modulate", train.modulate, Color(1,1,1,1), tween_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween.start()
		
		sky.visible = true
		city.visible = true
		behind_train.visible = true
		street.visible = true
		
		blammed_shader.set("shader_param/enabled", false)
		
		bar.get("custom_styles/fg").bg_color = game.bf.health_bar_color
		bar.get("custom_styles/bg").bg_color = game.dad.health_bar_color
		
		game.defaultCameraZoom = 1 + (1 - stage.camZoom)
		
		Conductor.disconnect("beat_hit", self, "beat_hit")
		
		queue_free()
	else:
		if cur_beat >= 128:
			sky.visible = false
			city.visible = false
			behind_train.visible = false
			street.visible = false
			
			visible = true
			
			blammed_shader.set("shader_param/enabled", true)
			
			game.gf.modulate = Color(get_light_color().r, get_light_color().g, get_light_color().b, game.gf.modulate.a)
			game.bf.modulate = get_light_color()
			game.dad.modulate = get_light_color()
			
			player_icon.modulate = get_light_color()
			enemy_icon.modulate = get_light_color()
			bar_outline.modulate = get_light_color()
			progress_bar_outline.modulate = get_light_color()
			train.modulate = get_light_color()
			
			bar.get("custom_styles/fg").bg_color = Color(0,0,0,1)
			bar.get("custom_styles/bg").bg_color = Color(0,0,0,1)
		
			if game.gf.modulate.a != 0:
				tween.interpolate_property(game.gf, "modulate:a", 1, 0, ((Conductor.timeBetweenSteps / Globals.song_multiplier) / 1000.0) * 2.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				tween.start()
			
			game.bf.modulate.a = 1
			game.dad.modulate.a = 1
			
			if cur_beat % 2 == 0:
				game.defaultCameraZoom = 0.8
				game.camera.zoom -= Vector2(0.1, 0.1)
				
				game.ui.scale += Vector2(0.05, 0.05)
				game.ui.offset += Vector2(-650 * 0.05, -400 * 0.05)
				
				set_particle_color(get_light_color())
				
				set_particles_emitting(true)
				
				yield(get_tree().create_timer(Conductor.timeBetweenSteps / Globals.song_multiplier, false), "timeout")
				
				set_particles_emitting(false)

func set_particles_emitting(val:bool):
	part1.emitting = val
	part2.emitting = val
	part3.emitting = val

func set_particle_color(color:Color):
	part1.process_material.set("color", color)
	part2.process_material.set("color", color)
	part3.process_material.set("color", color)

func get_light_color() -> Color:
	var lights = stage.get_node("ParallaxBackground/BG").get_children()
	
	for light in lights:
		if light.name.begins_with("Light "):
			if light.visible:
				match(int(light.name.replace("Light ", ""))):
					1:
						return Color(0.19, 0.64, 0.99, 1)
					2:
						return Color(0.19, 0.99, 0.55, 1)
					3:
						return Color(0.98, 0.2, 0.96, 1)
					4:
						return Color(0.99, 0.27, 0.19, 1)
					5:
						return Color(0.98, 0.65, 0.2, 1)
	
	return Color(1,1,1,1)
