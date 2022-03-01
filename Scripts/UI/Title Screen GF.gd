extends Node2D

var left = false

func dance():
	left = !left
	
	if left:
		$AnimatedSprite.play("danceLEFT")
	else:
		$AnimatedSprite.play("danceRIGHT")

func _ready():
	Conductor.connect("beat_hit", self, "dance")
