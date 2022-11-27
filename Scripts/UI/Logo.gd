extends AnimatedSprite

func _ready() -> void:
	Conductor.connect("beat_hit", self, "bop")
	
func bop() -> void:
	frame = 0
	play("idle")

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		material.set("shader_param/uTime", material.get("shader_param/uTime") + (delta * 0.1))
	if Input.is_action_pressed("ui_left"):
		material.set("shader_param/uTime", material.get("shader_param/uTime") - (delta * 0.1))
