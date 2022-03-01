extends "res://Scripts/Stage.gd"

var lastBeat = 0
var beatOffset = 8

onready var gameplay = $"../"

func _ready():
	randomize()
	Conductor.connect("beat_hit", self, "beat_hit")

func beat_hit():
	var beat = Conductor.curBeat
	
	if rand_int_val(1,10) == 3 and beat > lastBeat + beatOffset:
		lastBeat = beat
		
		gameplay.bf.timer = 0.0
		gameplay.bf.play_animation("scared", true)
		
		gameplay.gf.timer = 0.0
		gameplay.gf.play_animation("scared", true)
		
		$Background/AnimatedSprite.play("idle")
		$Background/AnimatedSprite.stop()
		$Background/AnimatedSprite.play("lightning")
		
		beatOffset = rand_int_val(8,24)
		
		get_node("Strike " + str(rand_int_val(1,2))).play()

func rand_int_val(minimum, maximum):
	return round(rand_range(minimum, maximum))
