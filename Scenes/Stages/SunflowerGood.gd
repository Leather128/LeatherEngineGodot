extends AnimatedSprite

func _ready():
	Conductor.connect("beat_hit", self, "beat_hit")

func beat_hit():
	frame = 0
	play("sunflower bop")
