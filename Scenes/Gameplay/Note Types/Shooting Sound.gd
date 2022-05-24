extends AudioStreamPlayer

func play_other_shit():
	yield(get_tree().create_timer(0.4), "timeout")
	$"../SplashImpact".play()
