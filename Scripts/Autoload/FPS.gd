extends Node2D

# Timestamps of frames rendered in the last second
var times := []

var fps := 0

var vram:float = 0.0

func _process(_delta: float) -> void:
	var now := OS.get_ticks_msec()

	# Remove frames older than 1 second in the `times` array
	while times.size() > 0 and times[0] <= now - 1000:
		times.pop_front()

	times.append(now)
	fps = times.size()
	
	vram = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 100000
	
	$"CanvasLayer/FPS Text".text = "FPS: " + str(fps)
	$"CanvasLayer/FPS Text".text += "\nVRAM: " + str(round(vram) / 10) + " MB"
