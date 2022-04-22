extends Node2D

var left = false

onready var shader = $AnimatedSprite.material

func dance():
	left = !left
	
	if left:
		$AnimatedSprite.play("danceLEFT")
	else:
		$AnimatedSprite.play("danceRIGHT")

func _ready():
	Conductor.connect("beat_hit", self, "dance")

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		shader.set("shader_param/uTime", shader.get("shader_param/uTime") + (delta * 0.1))
	if Input.is_action_pressed("ui_left"):
		shader.set("shader_param/uTime", shader.get("shader_param/uTime") - (delta * 0.1))
