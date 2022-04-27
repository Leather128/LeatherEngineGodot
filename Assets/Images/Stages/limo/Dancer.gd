extends Node2D

var left = false

onready var sprite = $AnimationPlayer

func _ready():
	dance()
	
	Conductor.connect("beat_hit", self, "dance")

func dance():
	if left:
		sprite.play("danceLeft")
	else:
		sprite.play("danceRight")
	
	left = !left
