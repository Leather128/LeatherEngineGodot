extends Node

onready var game = $"../"
onready var dad = game.dad

func _ready():
	Conductor.connect("step_hit", self, "step_hit")

func step_hit():
	if dad:
		match(Conductor.curStep):
			736:
				dad.dances = false
				dad.timer = 0
				game.defaultCameraZoom = (1 + (1 - game.stage.camZoom)) - 0.25
			768:
				dad.dances = true
				dad.timer = 0
				game.defaultCameraZoom = 1 + (1 - game.stage.camZoom)
