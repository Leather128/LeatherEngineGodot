extends Node

# hardcoded sprite bullshit because static variables don't exist :(
var held_sprites = {
	"left": [
		load("res://Assets/Images/Notes/default/held/left hold0000.png"),
		load("res://Assets/Images/Notes/default/held/left hold end0000.png")
	],
	"down": [
		load("res://Assets/Images/Notes/default/held/down hold0000.png"),
		load("res://Assets/Images/Notes/default/held/down hold end0000.png")
	],
	"up": [
		load("res://Assets/Images/Notes/default/held/up hold0000.png"),
		load("res://Assets/Images/Notes/default/held/up hold end0000.png")
	],
	"right": [
		load("res://Assets/Images/Notes/default/held/right hold0000.png"),
		load("res://Assets/Images/Notes/default/held/right hold end0000.png")
	],
	"square": [
		load("res://Assets/Images/Notes/default/held/square hold0000.png"),
		load("res://Assets/Images/Notes/default/held/square hold end0000.png")
	],
	"left2": [
		load("res://Assets/Images/Notes/default/held/left2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/left2 hold end0000.png")
	],
	"down2": [
		load("res://Assets/Images/Notes/default/held/down2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/down2 hold end0000.png")
	],
	"up2": [
		load("res://Assets/Images/Notes/default/held/up2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/up2 hold end0000.png")
	],
	"right2": [
		load("res://Assets/Images/Notes/default/held/right2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/right2 hold end0000.png")
	],
	"rleft": [
		load("res://Assets/Images/Notes/default/held/rleft hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rleft hold end0000.png")
	],
	"rdown": [
		load("res://Assets/Images/Notes/default/held/rdown hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rdown hold end0000.png")
	],
	"rup": [
		load("res://Assets/Images/Notes/default/held/rup hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rup hold end0000.png")
	],
	"rright": [
		load("res://Assets/Images/Notes/default/held/rright hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rright hold end0000.png")
	],
	"plus": [
		load("res://Assets/Images/Notes/default/held/plus hold0000.png"),
		load("res://Assets/Images/Notes/default/held/plus hold end0000.png")
	],
	"rleft2": [
		load("res://Assets/Images/Notes/default/held/rleft2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rleft2 hold end0000.png")
	],
	"rdown2": [
		load("res://Assets/Images/Notes/default/held/rdown2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rdown2 hold end0000.png")
	],
	"rup2": [
		load("res://Assets/Images/Notes/default/held/rup2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rup2 hold end0000.png")
	],
	"rright2": [
		load("res://Assets/Images/Notes/default/held/rright2 hold0000.png"),
		load("res://Assets/Images/Notes/default/held/rright2 hold end0000.png")
	],
}
