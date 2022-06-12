extends "res://Scripts/Stage.gd"

onready var spill = $ParallaxBackground/spill/spill

var del = 0
var del2 = 0

var agent:int = 1

onready var agents = [
	$ParallaxBackground/agents/agent1,
	$ParallaxBackground/agents/agent2,
	$ParallaxBackground/agents/agent3,
	$ParallaxBackground/agents/agent4,
	$ParallaxBackground/agents/agent5
]

onready var gf = $"../".gf

func _ready():
	Globals.connect("event_processed", self, "on_event")
	Conductor.connect("beat_hit", self, "beat_hit")

func _physics_process(_delta):
	if del > 0:
		del -= 1
	if del2 > 0:
		del2 -= 1

func beat_hit():
	if Conductor.curBeat == 120:
		agents[2].play("shoott")
		agents[2].frame = 0
	
	if Conductor.curBeat == 344:
		agents[1].play("shot")
		agents[1].frame = 0
		
		gf.play_animation("duck", true)
	
	for agent in agents:
		if agent.animation == "spawn" or agent.animation == "bop":
			agent.play("bop")
			agent.frame = 0

func on_event(event):
	if event[0].to_lower() == "bg freaks expression":
		agents[agent - 1].play("shoott")
		agents[agent - 1].frame = 0
		
		agent -= 1
		
		gf.play_animation("duck", true)
	
	if event[0].to_lower() == "trigger bg ghouls":
		if del2 > 0:
			agent = int(event[2])
			
			if event[3] != '':
				agent = int(event[3])
			
			agents[int(event[2]) - 1].play("spawn")
			agents[int(event[2]) - 1].frame = 0
		
		del2 = 3
	
	if event[0].to_lower() == "play animation":
		if event[2] == "spill":
			spill.visible = true
			spill.play("spill")
		
		if event[2] == "shoot" and del == 0:
			del = 3
			
			agents[agent - 1].play("shot")
			agents[agent - 1].frame = 0
			
			agent -= 1
			
			gf.play_animation("duck", true)
