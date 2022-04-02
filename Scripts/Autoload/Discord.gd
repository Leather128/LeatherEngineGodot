extends Node

var activity: Discord.Activity

func _ready():
	# if on Windows or Linux (currently supported platforms for RPC in Godot I think)
	if File.new().file_exists("res://addons/discord_game_sdk/discord_game_sdk.dll"):
		if OS.get_name().to_lower() == "windows" or OS.get_name().to_lower() == "x11":
			activity = Discord.Activity.new()
			activity.set_type(Discord.ActivityType.Playing)
			
			if OS.is_debug_build():
				activity.set_state("(Debug Mode)")
			
			activity.set_details("Starting Up The Game")
			
			var assets = activity.get_assets()
			assets.set_large_image("logo")
			assets.set_large_text("Leather Engine")
			
			var result = yield(Discord.activity_manager.update_activity(activity), "result").result
			
			if result != Discord.Result.Ok:
				push_error(result)

func update(details: String, state: String = "", small_image: String = "", small_image_text: String = "",
			large_image: String = "logo", large_image_text: String = "Leather Engine"):
	if File.new().file_exists("res://addons/discord_game_sdk/discord_game_sdk.dll"):
		if OS.get_name().to_lower() == "windows" or OS.get_name().to_lower() == "x11":
			if state:
				activity.set_state(state)
			else:
				activity.set_state("")
			
			activity.set_details(details)
			
			var assets = activity.get_assets()
			
			assets.set_large_image(large_image)
			assets.set_large_text(large_image_text)
			
			if small_image:
				assets.set_small_image(small_image)
			else:
				assets.set_small_image("")
			if small_image_text:
				assets.set_small_text(small_image_text)
			
			var result = yield(Discord.activity_manager.update_activity(activity), "result").result
			
			if result != Discord.Result.Ok:
				push_error(result)
