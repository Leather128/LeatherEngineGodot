extends TabContainer

onready var p1 = $"Art/Player 1"
onready var p2 = $"Art/Player 2"
onready var gf = $"Art/GF"

onready var stage = $"Art/Stage"

var characters = []
var stages = []

func _ready():
	read_chars()
	read_stages()

func read_stages():
	var dir = Directory.new()
	dir.open("res://Scenes/Stages/")
	
	dir.list_dir_begin()
	
	stages = []
	
	while true:
		var file = dir.get_next()
		
		if file == "":
			break
		elif file.ends_with(".tscn"):
			stages.append(file.replace(".tscn", ""))
	
	for stage_name in stages:
		stage.add_item(stage_name)
	
	if "stage" in $"../".song:
		if stages.find($"../".song["stage"]) != -1:
			stage.selected = stages.find($"../".song["stage"])
	else:
		if stages.find("stage") != -1:
			stage.selected = stages.find("stage")

func read_chars():
	var dir = Directory.new()
	dir.open("res://Scenes/Characters/")
	
	dir.list_dir_begin()
	
	characters = []
	
	while true:
		var file = dir.get_next()
		
		if file == "":
			break
		elif file.ends_with(".tscn"):
			characters.append(file.replace(".tscn", ""))
	
	for character in characters:
		p1.add_item(character)
		p2.add_item(character)
		gf.add_item(character)
	
	if characters.find($"../".song["player1"]) != -1:
		p1.selected = characters.find($"../".song["player1"])
	if characters.find($"../".song["player2"]) != -1:
		p2.selected = characters.find($"../".song["player2"])
	if "gf" in $"../".song:
		if characters.find($"../".song["gf"]) != -1:
			gf.selected = characters.find($"../".song["gf"])

func update_stuff(index):
	$"../".song["player1"] = characters[p1.selected]
	$"../".song["player2"] = characters[p2.selected]
	$"../".song["gf"] = characters[gf.selected]
	$"../".song["stage"] = stages[stage.selected]
