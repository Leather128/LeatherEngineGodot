extends LineEdit

onready var charter = $"../../../"

func update_stuff():
	charter.song.notes[charter.selected_section].bpm = float(text)
