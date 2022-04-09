extends Node

onready var player_strums = $"../UI/Player Strums"
onready var enemy_strums = $"../UI/Enemy Strums"

onready var og_window_pos:Vector2

var base_enemy_strum_x: float
var base_player_strum_x: float

var enemy_speed: float = 24
var enemy_i_multi: float = 1

var player_speed: float = 24
var player_i_multi: float = 1

func _ready():
	randomize()
	
	enemy_speed = rand_range(20, 24)
	enemy_i_multi = rand_range(0.8, 1.2)
	
	player_speed = rand_range(24, 28)
	player_i_multi = rand_range(1, 1.4)
	
	base_enemy_strum_x = enemy_strums.global_position.x
	base_player_strum_x = player_strums.global_position.x
	
	enemy_strums.modulate.a = 0.5
	player_strums.modulate.a = 0.5
	
	OS.center_window()
	
	og_window_pos = OS.window_position

func _physics_process(_delta):
	var window_stuff:float = (Conductor.songPosition / 1000.0) * 2.5
	OS.window_position = og_window_pos + Vector2(sin(window_stuff) * 10, cos(window_stuff) * 10)

func _process(delta):
	if Conductor.songPosition > 12500:
		enemy_strums.modulate.a = 1
		
		enemy_strums.global_position.x = base_enemy_strum_x + (sin((Conductor.songPosition / 1000) * 5) * 10)
		
		if enemy_strums.visible:
			for i in enemy_strums.get_child_count():
				var strum = enemy_strums.get_child(i)
				strum.position.y = sin((Conductor.songPosition / 1000) * (float(i + 1) * enemy_i_multi)) * enemy_speed
		
		if Conductor.songPosition > 14300:
			player_strums.modulate.a = 1
			
			player_strums.global_position.x = base_player_strum_x + (cos((Conductor.songPosition / 1000) * 5) * 10)
			
			if player_strums.visible:
				for i in player_strums.get_child_count():
					var strum = player_strums.get_child(i)
					strum.position.y = cos((Conductor.songPosition / 1000) * (float(4 - i) * player_i_multi)) * player_speed
