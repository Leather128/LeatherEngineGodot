extends Node

var bf:Node2D
var dad:Node2D
var gf:Node2D

func _ready():
	bf = $"../".bf
	dad = $"../".dad
	gf = $"../".gf
	
	Conductor.connect("beat_hit", self, "beat_hit")

func beat_hit():
	if Conductor.curBeat > 16 and Conductor.curBeat < 48:
		if Conductor.curBeat % 16 == 15 and bf:
			bf.timer = 0
			bf.play_animation("hey", true)
			
			if gf != dad:
				gf.timer = 0
				gf.play_animation("cheer", true)
			else:
				dad.timer = 0
				dad.play_animation("cheer", true)
