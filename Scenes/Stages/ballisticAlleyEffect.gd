extends Sprite

onready var game = $"../../../"

func _physics_process(delta: float) -> void:
	modulate.a = 1 - (game.health - 0.3)
	position.y = -200
