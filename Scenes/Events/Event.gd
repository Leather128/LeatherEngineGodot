class_name Event
extends Node

# cool variables :D
onready var game = $"../"

onready var bf = game.bf
onready var dad = game.dad
onready var gf = game.gf

func process_event(argument_1, argument_2):
	pass

func get_character_from_argument(argument) -> Node2D:
	match(argument.to_lower()):
		"girlfriend","gf","player3","2":
			return gf
		"dad","opponent","player2","1":
			return dad
		_:
			return bf
