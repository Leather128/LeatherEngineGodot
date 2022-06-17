extends Panel

var files:Array = [
	"res://Scenes/Mods/Mod.tscn"
]

onready var choose_files = $"../ChooseFiles"

onready var text_box = $TextEdit

func update_text():
	text_box.text = ""
	
	for file in files:
		text_box.text += file + "\n"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	Fps.get_node("CanvasLayer/FPS Text").visible = false
	
	update_text()

func _process(_delta):
	if Input.is_action_just_pressed("ui_escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
		Fps.get_node("CanvasLayer/FPS Text").visible = true
		
		Scenes.switch_scene("Tools Menu")

func popup():
	choose_files.popup()

func reset_files():
	files = [
		"res://Scenes/Mods/Mod.tscn"
	]
	
	update_text()

func add_files(_files:Array):
	for file in _files:
		if !files.has(file):
			files.append(file)
	
	update_text()

func add_file(file:String):
	if !files.has(file):
		files.append(file)
	
	update_text()

func pack_pck():
	var packer = PCKPacker.new()
	packer.pck_start("Mod.pck")
	
	for file in files:
		packer.add_file(file, file)
	
	packer.flush()

func update_files_from_text():
	files = text_box.text.split("\n", false)
