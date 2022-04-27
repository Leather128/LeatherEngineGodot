extends Node

func _ready():
	Conductor.connect("beat_hit", self, "beat_hit")

func beat_hit():
	if Conductor.curBeat >= 168 and Conductor.curBeat < 200:
		$"../Camera2D".zoom -= Vector2(0.015, 0.015)
		$"../UI".scale += Vector2(0.03, 0.03)
		$"../UI".offset += Vector2(-22.5, -15)
