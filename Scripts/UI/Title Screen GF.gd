extends Node2D

var left = false

onready var animated_sprite = $AnimatedSprite
onready var shader = animated_sprite.material

func dance():
	left = !left
	
	if left:
		animated_sprite.play("danceLEFT")
	else:
		animated_sprite.play("danceRIGHT")

func _ready():
	Conductor.connect("beat_hit", self, "dance")

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		shader.set("shader_param/uTime", shader.get("shader_param/uTime") + (delta * 0.1))
	if Input.is_action_pressed("ui_left"):
		shader.set("shader_param/uTime", shader.get("shader_param/uTime") - (delta * 0.1))
