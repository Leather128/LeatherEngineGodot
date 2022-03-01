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
