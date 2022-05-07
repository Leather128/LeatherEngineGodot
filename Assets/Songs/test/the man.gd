extends CanvasLayer

onready var dad = load("res://Scenes/Characters/dad.tscn")
onready var bf_pixel = load("res://Scenes/Characters/bf-pixel.tscn")

onready var game = $"../"

onready var opp = game.dad
onready var bf = game.bf
onready var gf = game.gf

onready var dad_icon = game.get_node("UI/Health Bar/Opponent")
onready var health_bar = game.get_node("UI/Health Bar/Bar/ProgressBar")

onready var dad_texture = load("res://Assets/Images/Icons/dad-icons.png")
onready var bf_pixel_texture = load("res://Assets/Images/Icons/bf-pixel-icons.png")

onready var dad_point = game.stage.get_node("Dad Point")
onready var bf_point = game.stage.get_node("Player Point")

onready var sprite = $Sprite

var tween = Tween.new()

var shifting = false

onready var hue = $Hue
onready var mat = hue.get("material")

var dad_pos:Vector2
var bf_pos:Vector2

var moving_shit = false

var timer:float = 0.0

var og_speed:float = 0.0

onready var stage = game.stage

var dif_changing = false

onready var pro_text = game.get_node("UI/Progress Bar/Text")

onready var pixel = $Pixelate

onready var player_strums = game.get_node("UI/Player Strums")
onready var enemy_strums = game.get_node("UI/Enemy Strums")
onready var enemy_notes = game.get_node("UI/Enemy Notes")

onready var base_x = player_strums.position.x
onready var en_base_x = enemy_strums.position.x

onready var base_y = player_strums.position.y
onready var en_base_y = enemy_strums.position.y

onready var progress_bar = game.get_node("UI/Progress Bar")
onready var health_bar_good = game.get_node("UI/Health Bar")

onready var gameplay_text = game.get_node("UI/Gameplay Text")

var insanity:bool = false

onready var distort = $Distort

func _ready():
	add_child(tween)
	Conductor.connect("step_hit", self, "step_hit")
	
	tween.interpolate_property(sprite, "modulate:a", sprite.modulate.a, 0.9, 5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(sprite.get("material"), "shader_param/uSpeed", 5, 1, 5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 1)
	tween.interpolate_property(sprite.get("material"), "shader_param/uFrequency", 15, 1, 2.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 2)
	tween.interpolate_property(sprite.get("material"), "shader_param/uWaveAmplitude", 0.5, 0.1, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 3)
	tween.start()
	
	if !insanity:
		sprite.get_node("RichTextLabel").visible = false
		
		for i in get_children():
			if i.name.begins_with("DVD"):
				i.queue_free()

func _process(delta):
	if !insanity:
		hue.visible = false
		pixel.visible = false
		distort.visible = false
	
	if dif_changing:
		pro_text.bbcode_text = pro_text.bbcode_text.replace("NORMAL", "GODOT")
	
	if shifting:
		mat.set("shader_param/uTime", mat.get("shader_param/uTime") + (delta * 0.1))
	
	if moving_shit:
		timer += delta
		
		opp.position = dad_pos + Vector2(cos(timer * 2) * 100, sin(timer * 2) * 100)
		bf.position = bf_pos + Vector2(sin(timer * 2) * 100, cos(timer * 2) * 100)
		
		GameplaySettings.scroll_speed = og_speed + abs((tan(timer * 10) * 0.1))
		
		stage.scale = Vector2(1,1) + Vector2(cos(timer * 2) + 1, sin(timer * 2) + 1)
		
		player_strums.position.x = base_x + (sin(timer * 2) * 205) - 180
		enemy_strums.position.x = en_base_x + (cos(timer * 2) * 205) + 180
		
		player_strums.position.y = base_y + (sin(timer * 2) * 15) + 7.5
		enemy_strums.position.y = en_base_y + (cos(timer * 2) * 15) - 7.5
		
		enemy_strums.modulate.a = 0.25
		enemy_notes.modulate.a = 0.25
		
		progress_bar.position.x = 329 + (sin(timer * 2) * 50)
		health_bar_good.position.x = 329 + (cos(timer * 2) * 50)
		
		gameplay_text.position.x = (sin(timer * 2) * 25)

func step_hit():
	var step = Conductor.curStep
	
	if step % 16 == 0:
		pixel.visible = !pixel.visible
	
	if step % 4 == 3 and step < 127:
		game.remove_child(opp)
		opp = dad.instance()
		opp.position = dad_point.position
		game.add_child(opp)
		game.dad = opp
		dad_icon.texture = dad_texture
		health_bar.get("custom_styles/bg").bg_color = opp.health_bar_color
	elif step % 4 == 1 and step < 127:
		game.remove_child(opp)
		opp = bf_pixel.instance()
		opp.position = dad_point.position
		game.add_child(opp)
		game.dad = opp
		dad_icon.texture = bf_pixel_texture
		health_bar.get("custom_styles/bg").bg_color = opp.health_bar_color
	
	match(step):
		121:
			tween.interpolate_property(opp, "modulate:a", opp.modulate.a, 0.5, 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.start()
		126:
			tween.interpolate_property(opp, "modulate:a", opp.modulate.a, 0, 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.start()
		128:
			tween.stop_all()
			tween.interpolate_property(opp, "modulate:a", opp.modulate.a, 1, 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.interpolate_property(sprite, "modulate:a", sprite.modulate.a, 0.3, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			sprite.get_node("RichTextLabel").visible = false
			tween.start()
			
			dif_changing = true
		192:
			tween.interpolate_property(sprite, "modulate:a", sprite.modulate.a, 0.1, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.interpolate_property(gf, "position:y", gf.position.y, gf.position.y + 500, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.interpolate_property(opp, "position:y", opp.position.y, opp.position.y - 500, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.interpolate_property(dad_point, "position:y", dad_point.position.y, dad_point.position.y - 500, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.start()
		208:
			tween.interpolate_property(sprite, "modulate:a", sprite.modulate.a, 0.05, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.interpolate_property(bf, "position:y", bf.position.y, bf.position.y - 500, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.interpolate_property(bf_point, "position:y", bf_point.position.y, bf_point.position.y - 500, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.start()
			
			shifting = true
			hue.visible = true
		384:
			dad_pos = opp.position
			bf_pos = bf.position
			og_speed = GameplaySettings.scroll_speed
			moving_shit = true
		704:
			tween.interpolate_property(gf, "position:y", gf.position.y, gf.position.y - 1000, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			
			shifting = false
			tween.interpolate_property(hue, "modulate:a", hue.modulate.a, 0, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			tween.start()
