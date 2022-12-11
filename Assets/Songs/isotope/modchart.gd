extends Node2D

onready var game: Node2D = $"../"

func _ready() -> void:
	if not Settings.get_data('middlescroll'):
		var old_p_strum_x: float = game.player_strums.global_position.x
		
		game.player_strums.global_position.x = game.enemy_strums.global_position.x
		game.enemy_strums.global_position.x = old_p_strum_x
	
	game.enemy_strums.visible = false
	game.enemy_notes.visible = false
