extends Node2D

func _ready():
	Conductor.connect("beat_hit", self, "bop")
	
func bop():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("idle")
