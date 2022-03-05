extends CanvasLayer

onready var game = $"../../"

onready var effect = $Sprite

func _process(_delta):
	effect.modulate.a = (game.health / 2) - 0.4
