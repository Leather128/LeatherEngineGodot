extends Node

onready var dad = $"../".dad

func _ready():
	Conductor.connect("step_hit", self, "step_hit")

func step_hit():
	match(Conductor.curStep):
		60, 444, 524, 540, 541, 829:
			if dad:
				dad.timer = 0
				dad.play_animation("ugh")
