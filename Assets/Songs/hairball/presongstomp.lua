local allowCountdown = false
function onStartCountdown()
	if not allowCountdown and isStoryMode and not seenCutscene then --Block the first countdown
		playSound('brokenpad', 10)
		allowCountdown = true;
		
		return Function_Stop;
	end
	return Function_Continue;
end