extends "res://Scripts/Stage.gd"

var trainCooldown: float = 0.0
var trainFrameTiming: float = 0.0
var trainCars: float = 0.0
var time: float = 0.0

var trainMoving = false
var startedMoving = false
var trainFinishing = false

onready var parallax_bg = get_node("ParallaxBackground/BG")

onready var train = $Train
onready var train_spr = $ParallaxBackground/Foreground/Train

onready var gf = $"../".gf
onready var gf_anim = gf.get_node("AnimationPlayer")

onready var tween = Tween.new()

func _ready():
	add_child(tween)
	
	randomize()
	
	Conductor.connect("beat_hit", self, "on_beat")

func _physics_process(delta):
	if trainMoving:
		trainFrameTiming += delta

		if trainFrameTiming >= 1.0 / 24.0:
			updateTrainPos()
			trainFrameTiming = 0.0

func on_beat():
	if not trainMoving:
		trainCooldown = trainCooldown + 1

	if Conductor.curBeat % 4 == 0:
		var lightSelected = int(rand_range(1, 5))

		for child in parallax_bg.get_children():
			if child.name.begins_with("Light "):
				child.visible = false
		
		var light = parallax_bg.get_node("Light " + str(lightSelected))
		
		light.visible = true
		
		tween.interpolate_property(light, "modulate", Color(1,1,1,1), Color(1,1,1,0), (Conductor.timeBetweenBeats / 1000) * 4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.stop_all()
		tween.start()

	if Conductor.curBeat % 8 == 4 and rand_range(0, 100) < 20 and not trainMoving and trainCooldown > 8:
		trainCooldown = int(rand_range(-4, 0))
		
		trainMoving = true
		train.play(0)

func updateTrainPos():
	if train.get_playback_position() * 1000 >= 4700:
		if "dances" in gf:
			gf.dances = false
		
		if !startedMoving:
			gf.play_animation("hairBlow", true)
		
		startedMoving = true
		
		if gf_anim.get_current_animation_position() >= 0.16:
			gf.play_animation("hairBlow", true)

	if startedMoving:
		train_spr.position.x = train_spr.position.x - 400
		
		if train_spr.position.x < -2000 and not trainFinishing:
			train_spr.position.x = -1150
			trainCars = trainCars - 1
			
			if trainCars <= 0:
				trainFinishing = true
		
		if train_spr.position.x < -4000 and trainFinishing:
			trainReset()

func trainReset():
	gf.play_animation("hairFall", true)
	
	train_spr.position.x = 2000
	trainMoving = false
	trainCars = 8
	trainFinishing = false
	startedMoving = false
	
	if "dances" in gf:
		gf.dances = true
