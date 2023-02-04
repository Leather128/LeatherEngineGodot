extends Node2D

onready var game = $"../"
var state: int = -1
var switch: bool = false
var debug: bool = false

func _ready() -> void:
	Conductor.connect('step_hit', self, 'step_hit')

func _process(delta: float) -> void:
	if debug:
		if Input.is_action_just_pressed('ui_shift'):
			switch = not switch
		
		if switch:
			Globals.song_multiplier = 15.0
			game.inst.pitch_scale = 15.0
			game.voices.pitch_scale = 15.0
			game.ui.scale = Vector2(1, 1)
			game.ui.offset = Vector2(0, 0)
		else:
			Globals.song_multiplier = 1.0
			game.inst.pitch_scale = 1.0
			game.voices.pitch_scale = 1.0

func step_hit() -> void:
	match state:
		-1:
			if Conductor.curStep >= 2559:
				game.dad.play_animation("scene", true)
				state = 0
		0:
			if Conductor.curStep >= 2576:
				game.bf.play_animation("scene", true)
				state = 1
