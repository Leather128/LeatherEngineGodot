class_name Cutscene
extends Node

onready var game: Node2D = $"../"

onready var bf: Character = game.bf
onready var dad: Character = game.dad
onready var gf: Character = game.gf

onready var stage: Node2D = game.stage

onready var camera: Camera2D = game.get_node("Camera")

signal finished

func _ready() -> void:
	Scenes.current_scene = "Cutscene"
