extends SansAttack

func _ready():
	soul.switch_mode(1)
	
	game.resize_box(530, 260)

func attack_step():
	var ply = 60
	
	if attack_timer == 1:
		print("part 1")
		
		spawn_bullet('plat2', -600, ply, 4.1, 0)
		spawn_bullet('plat2', -1000, ply, 4.1, 0)
		spawn_bullet('plat2', -1400, ply, 4.1, 0)
		spawn_bullet('boneV2', -1700, ply - 130, 5, 0)
		spawn_bullet('boneV2', -1730, ply - 130, 5, 0)
		spawn_bullet('boneV2', -1760, ply - 130, 5, 0)
	if attack_timer == 350:
		print("part 2")
		
		spawn_bullet('boneV3', -600, ply - 130, 6, 0)
		spawn_bullet('boneV3', -700, 10, 6, 0, -1)
		spawn_bullet('boneV1', -900, 100, 6, 0)
		spawn_bullet('boneV3', -900, -130, 6, 0)
	if attack_timer == 480:
		print("part 3 (BLASTER?!?!?!)")
		
		spawn_bullet('blaster', -200, -300, 0, 0, 1, 270, 1.1)
	if int(attack_timer) % 10 == 0 and attack_timer < 340:
		print("spawn fast bone")
		
		spawn_bullet('boneV1', -400, 140, 4, 0, 0.9)
