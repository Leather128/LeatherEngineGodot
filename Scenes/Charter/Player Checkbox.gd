extends CheckBox

onready var charter = $"../../../"

func _ready():
	charter.connect("changed_section", self, "update_value")
	update_value()

func update_value():
	pressed = charter.song.notes[charter.selected_section].mustHitSection
