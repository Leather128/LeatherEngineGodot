extends "res://Scripts/Stage.gd"

func _ready():
	Globals.connect("event_processed", self, "on_event")

func on_event(event):
	if event[0].to_lower() == "play animation":
		print("yay")
