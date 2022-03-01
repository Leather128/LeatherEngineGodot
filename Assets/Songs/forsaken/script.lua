local allowCountdown = false;
local idk = false;
local left = {'NONE', 'BD', 'NONE', 'BE', 'BB', 'BB', 'NONE', 'NONE', 'BA', 'MB', 'BC', 'NONE', 'BB', 'NONE'};
local right = {'GB', 'NONE', 'B', 'NONE', 'NONE', 'NONE', 'C', 'C', 'NONE', 'NONE', 'NONE', 'D', 'NONE', 'D'};

function onCreate()
	if isStoryMode then
		makeLuaSprite('no', 'celeste/void2', 0, 0);
		setObjectCamera('no', 'camHud');
		scaleObject('no', 1280/200, 720/200);
		addLuaSprite('no', true);
	end

	makeLuaSprite('void2', 'celeste/void2', 0, 0);
	setObjectCamera('void2', 'camHud');
	scaleObject('void2', 1280/200, 720/200);
end

function onStartCountdown()
	if not allowCountdown and isStoryMode and not seenCutscene then
		setProperty('inCutscene', true);
		runTimer('startDialogue', 0.1);
		allowCountdown = true;
		return Function_Stop;
	end
	if seenCutscene then
		doTweenAlpha('no', 'no', 0, 1, 'linear');
	end
	if idk == true then
		removeLuaSprite('portraits', true);
		removeLuaSprite('portraits2', true);
	end
	return Function_Continue;
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then 
		startDialogue('dialogueForsaken','Badeline_ambience_buildup_loop');
		makeAnimatedLuaSprite('portraits', 'celeste/portraits', 215, 85);
		addAnimationByPrefix('portraits', 'BA', 'BA', 8, false);
		addAnimationByPrefix('portraits', 'BB', 'BB', 8, false);
		addAnimationByPrefix('portraits', 'BC', 'BC', 8, false);
		addAnimationByPrefix('portraits', 'BD', 'BD', 8, false);
		addAnimationByPrefix('portraits', 'BE', 'BE', 8, false);

		addAnimationByPrefix('portraits', 'MB', 'MB', 8, false);

		addAnimationByPrefix('portraits', 'NONE', 'none', 8, false);
		setObjectCamera('portraits', 'camHud');
		scaleObject('portraits', 0.65, 0.65);
		addLuaSprite('portraits', true);

		makeAnimatedLuaSprite('portraits2', 'celeste/portraits', 1015, 85);
		addAnimationByPrefix('portraits2', 'NONE', 'none', 8, false);
		addAnimationByPrefix('portraits2', 'A', 'BFA', 8, false);
		addAnimationByPrefix('portraits2', 'B', 'BFB', 8, false);
		addAnimationByPrefix('portraits2', 'C', 'BFC', 8, false);
		addAnimationByPrefix('portraits2', 'D', 'BFD', 8, false);
		addAnimationByPrefix('portraits2', 'GA', 'GFA', 8, false);
		addAnimationByPrefix('portraits2', 'GB', 'GFB', 8, false);
		setObjectCamera('portraits2', 'camHud');
		scaleObject('portraits2', 0.65, 0.65);
		addLuaSprite('portraits2', true);

		objectPlayAnimation('portraits', 'NONE', true);
		objectPlayAnimation('portraits2', 'C', true);
	end
end

function onNextDialogue(line)
	doTweenAlpha('no', 'no', 0, 1, 'linear');
	idk = true;
	objectPlayAnimation('portraits', left[line], true);
	objectPlayAnimation('portraits2', right[line], true);
end