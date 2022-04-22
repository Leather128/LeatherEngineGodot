extends Node2D

func _ready():
	Conductor.connect("beat_hit", self, "bop")
	
func bop():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("idle")

onready var shader = $AnimatedSprite.material

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		shader.set("shader_param/uTime", shader.get("shader_param/uTime") + (delta * 0.1))
	if Input.is_action_pressed("ui_left"):
		shader.set("shader_param/uTime", shader.get("shader_param/uTime") - (delta * 0.1))
