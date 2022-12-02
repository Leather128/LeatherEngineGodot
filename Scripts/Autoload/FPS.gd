extends CanvasLayer

var vram: float = 0.0

var mem: float = 0.0
var mem_peak: float = 0.0

onready var debug: bool = OS.is_debug_build()

onready var fps_text: Label = $fps

var delta_fps: float = 0

var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	
	timer.start(0.25)
	timer.connect("timeout", self, "_update")
	
	_update()

func _update():
	vram = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 104857.6
	
	fps_text.text = str(Performance.get_monitor(Performance.TIME_FPS)) + "fps"
	
	if debug:
		mem = Performance.get_monitor(Performance.MEMORY_STATIC) / 104857.6
		mem_peak = Performance.get_monitor(Performance.MEMORY_STATIC_MAX) / 104857.6
		
		fps_text.text += "\n" + str(round(mem) / 10) + " / " + str(round(mem_peak) / 10) + "mb"
	
	fps_text.text += "\n" + str(round(vram) / 10) + "mb (vram)"
