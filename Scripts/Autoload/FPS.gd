extends Node2D

# Timestamps of frames rendered in the last second
var times := []

var fps := 0

var vram:float = 0.0

var extra_debug:bool = false

var debug_names = [
	"TIME_FPS",
	"TIME_PROCESS",
	"TIME_PHYSICS_PROCESS",
	"MEMORY_STATIC",
	"MEMORY_DYNAMIC",
	"MEMORY_STATIC_MAX",
	"MEMORY_DYNAMIC_MAX",
	"MEMORY_MESSAGE_BUFFER_MAX",
	"OBJECT_COUNT",
	"OBJECT_RESOURCE_COUNT",
	"OBJECT_NODE_COUNT",
	"OBJECT_ORPHAN_NODE_COUNT",
	"RENDER_2D_ITEMS_IN_FRAME",
	"RENDER_2D_DRAW_CALLS_IN_FRAME",
	"RENDER_VIDEO_MEM_USED",
	"RENDER_TEXTURE_MEM_USED",
	"RENDER_VERTEX_MEM_USED",
	"RENDER_USAGE_VIDEO_MEM_TOTAL",
	"PHYSICS_2D_ACTIVE_OBJECTS",
	"PHYSICS_2D_COLLISION_PAIRS",
	"PHYSICS_2D_ISLAND_COUNT",
	"AUDIO_OUTPUT_LATENCY"
]

onready var debug_text = $"CanvasLayer/Debug Text"
onready var fps_text = $"CanvasLayer/FPS Text"

func _ready():
	if not extra_debug:
		debug_text.visible = false

func _process(_delta: float) -> void:
	var now := OS.get_ticks_msec()

	# Remove frames older than 1 second in the `times` array
	while times.size() > 0 and times[0] <= now - 1000:
		times.pop_front()

	times.append(now)
	fps = times.size()
	
	vram = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 100000
	
	fps_text.text = "FPS: " + str(fps)
	fps_text.text += "\nVRAM: " + str(round(vram) / 10) + " MB"
	
	if extra_debug:
		debug_text.text = ""
		
		for i in len(debug_names):
			debug_text.text += str(debug_names[i]) + ": " + str(Performance.get_monitor(Performance.get(debug_names[i])))
			debug_text.text += "\n"
