extends Node

onready var game: Node2D = $"../"

func _ready() -> void:
	Globals.connect("enemy_note_hit", self, "drain_health")

func drain_health(_1, _2, _3, _4) -> void:
	if game.health > 0.1:
		game.health -= 0.1
