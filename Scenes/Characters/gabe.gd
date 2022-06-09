extends "res://Scripts/Character.gd"

func _ready():
	Globals.connect("event_processed", self, "eventlol")

func eventlol(event):
	if event[0].to_lower() == "alt idle animation":
		
