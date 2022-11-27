extends AnimatedSprite

var left: bool = false

func _ready() -> void:
	Conductor.connect("beat_hit", self, "dance")

func dance() -> void:
	left = !left
	
	if left: play("danceLeft")
	else: play("danceRight")

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		material.set("shader_param/uTime", material.get("shader_param/uTime") + (delta * 0.1))
	if Input.is_action_pressed("ui_left"):
		material.set("shader_param/uTime", material.get("shader_param/uTime") - (delta * 0.1))
