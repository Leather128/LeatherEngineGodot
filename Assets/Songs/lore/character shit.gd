extends Node

onready var game: Node2D = $"../"

onready var guy: Node2D = game.bf
onready var phone: Node2D = game.gf

onready var stage: Node2D = game.stage

onready var p_point: Node2D = stage.get_node("Player Point")
onready var g_point: Node2D = stage.get_node("GF Point")

onready var player_health_icon: Sprite = game.get_node("UI/Health Bar/Player")
onready var health_bar: StyleBoxFlat = game.get_node("UI/Health Bar/Bar/ProgressBar").get("custom_styles/fg")

func _ready() -> void:
	Conductor.connect("beat_hit", self, "beat_hit")

func beat_hit() -> void:
	var cur_beat = Conductor.curBeat
	
	match(cur_beat):
		448, 512, 593:
			switch_phone()
		481, 545, 608:
			switch_guy()

func switch_phone() -> void:
	if stage and g_point and p_point and phone and guy:
		var old_g_pos = g_point.position
		var old_p_pos = p_point.position
		
		game.gf = guy
		game.bf = phone
		
		p_point.position = old_g_pos
		g_point.position = old_p_pos
		
		player_health_icon.texture = game.bf.health_icon
		health_bar.bg_color = game.bf.health_bar_color

func switch_guy() -> void:
	if stage and g_point and p_point and phone and guy:
		var old_g_pos = g_point.position
		var old_p_pos = p_point.position
		
		game.gf = phone
		game.bf = guy
		
		p_point.position = old_g_pos
		g_point.position = old_p_pos
		
		player_health_icon.texture = game.bf.health_icon
		health_bar.bg_color = game.bf.health_bar_color
