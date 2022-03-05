extends Node

enum NoteDirection {
	Left,
	Down,
	Up,
	Right,
	Left2,
	Down2,
	Up2,
	Right2,
	Square
	RLeft,
	RUp,
	RDown,
	RRight,
	RLeft2,
	RUp2,
	RDown2,
	RRight2,
	Plus
}

func dir_to_str(cool_dir):
	return NoteDirection.keys()[cool_dir].to_lower()

func dir_to_animstr(dir):
	var str_dir = dir_to_str(dir).to_lower()
	str_dir = str_dir.replace("2", "")
	
	if str_dir.begins_with("r"):
		str_dir = str_dir.right(1)
	
	if str_dir == "ight":
		str_dir = "right"
	
	match(str_dir):
		"plus","square":
			return "up"
		_:
			return str_dir
