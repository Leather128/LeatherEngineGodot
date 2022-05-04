extends Node

onready var dad = $"../".dad

func _ready():
	Conductor.connect("step_hit", self, "step_hit")

func step_hit():
	match(Conductor.curStep):
		736:
			dad.dances = false
			dad.timer = 0
		768:
			dad.dances = true
			dad.timer = 0
