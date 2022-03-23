extends TabContainer

onready var p1 = $"Art/Player 1"
onready var p2 = $"Art/Player 2"
onready var gf = $"Art/GF"

onready var stage = $"Art/Stage"

onready var ui_skin = $"Art/UI Skin"

onready var key_count = $"Chart/Key Count"

var characters = []
var stages = []
var ui_skins = []

func _ready():
	read_chars()
	read_stages()
	read_skins()
	
	if not "keyCount" in $"../".song:
		$"../".song["keyCount"] = GameplaySettings.key_count
	
	key_count.text = str($"../".song["keyCount"])

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

func read_skins():
	var dir = Directory.new()
	dir.open("res://Scenes/UI Skins/")
	
	dir.list_dir_begin()
	
	ui_skins = []
	
	while true:
		var file = dir.get_next()
		
		if file == "":
			break
		elif file.ends_with(".tscn"):
			ui_skins.append(file.replace(".tscn", ""))
	
	for skin in ui_skins:
		ui_skin.add_item(skin)
	
	if ui_skins.find($"../".song["ui_skin"]) != -1:
		ui_skin.selected = ui_skins.find($"../".song["ui_skin"])

func update_stuff(_index = 0):
	$"../".song["player1"] = characters[p1.selected]
	$"../".song["player2"] = characters[p2.selected]
	$"../".song["gf"] = characters[gf.selected]
	$"../".song["stage"] = stages[stage.selected]
	
	if len(ui_skins) > 0:
		$"../".song["ui_skin"] = ui_skins[ui_skin.selected]
	
	if load("res://Scenes/Gameplay/Strums/" + key_count.text + ".tscn") != null:
		$"../".song["keyCount"] = int(key_count.text)
