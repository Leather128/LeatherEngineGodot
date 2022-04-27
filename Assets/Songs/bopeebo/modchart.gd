extends Node

var bf:Node2D

func _ready():
	bf = $"../".bf
	
	Conductor.connect("beat_hit", self, "beat_hit")

func beat_hit():
	if Conductor.curBeat % 8 == 7 and bf:
		bf.timer = 0
		bf.play_animation("hey", true)
