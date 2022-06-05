extends Node2D

var vram:float = 0.0

var mem:float = 0.0
var mem_peak:float = 0.0

onready var debug:bool = OS.is_debug_build()

onready var fps_text = $"CanvasLayer/FPS Text"

var delta_fps: float = 0

func _physics_process(_delta):
	vram = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 100000
	
	fps_text.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	
	if debug:
		mem = Performance.get_monitor(Performance.MEMORY_STATIC) / 100000
		mem_peak = Performance.get_monitor(Performance.MEMORY_STATIC_MAX) / 100000
		
		fps_text.text += "\nMEM: " + str(round(mem) / 10) + " MB"
		fps_text.text += "\nMEM Peak: " + str(round(mem_peak) / 10) + " MB"
	
	fps_text.text += "\nVRAM: " + str(round(vram) / 10) + " MB"
