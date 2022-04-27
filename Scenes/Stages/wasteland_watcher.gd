extends AnimatedSprite

func _ready():
	Conductor.connect("beat_hit", self, "dance")

func dance():
	frame = 0
	stop()
	play("idle")
