extends "res://Scripts/Stage.gd"

onready var sky = $ParallaxBackground/Sky/Sprite
onready var city = $ParallaxBackground/City/Sprite
onready var tree_b = $"ParallaxBackground/Tree B/Sprite"
onready var tree_a = $"ParallaxBackground/Tree A/Sprite"
onready var ground = $ParallaxBackground/Ground/Sprite

func _ready():
	match(GameplaySettings.songName.to_lower()):
		"spine-crusher", "spine crusher":
			reload_assets()
		"mas-fuerte-que-tu", "mas fuerte que tu", "megalovania": # unused in base lua lmao
			reload_assets("-night")
		_:
			reload_assets("-day") # just in case

func reload_assets(ending:String = ""):
	sky.texture = load("res://Assets/Images/Stages/out/sky" + ending + ".png")
	city.texture = load("res://Assets/Images/Stages/out/mount" + ending + ".png")
	tree_b.texture = load("res://Assets/Images/Stages/out/tree_b" + ending + ".png")
	tree_a.texture = load("res://Assets/Images/Stages/out/tree_a" + ending + ".png")
	ground.texture = load("res://Assets/Images/Stages/out/ground" + ending + ".png")
