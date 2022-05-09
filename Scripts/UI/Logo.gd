extends Node2D

onready var animated_sprite = $AnimatedSprite

func _ready():
	Conductor.connect("beat_hit", self, "bop")
	
func bop():
	animated_sprite.frame = 0
	animated_sprite.play("idle")

onready var shader = animated_sprite.material

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		shader.set("shader_param/uTime", shader.get("shader_param/uTime") + (delta * 0.1))
	if Input.is_action_pressed("ui_left"):
		shader.set("shader_param/uTime", shader.get("shader_param/uTime") - (delta * 0.1))
