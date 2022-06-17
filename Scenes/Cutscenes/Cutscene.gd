class_name Cutscene
extends Node

onready var game = $"../"

onready var bf = game.bf
onready var dad = game.dad
onready var gf = game.gf

onready var stage = game.stage

onready var camera = game.get_node("Camera2D")

signal finished

func _ready():
	Scenes.current_scene = "Cutscene"
