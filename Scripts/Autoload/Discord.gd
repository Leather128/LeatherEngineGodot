extends Node

# warnings-disable

var discord_rpc: DiscordRPC

# https://discord.com/developers/applications/
# application_id: Found in 'Genneral' information' & OAuth2'
var application_id: int = 864980501004812369
var presence: RichPresence = RichPresence.new()

var debug_printing: bool = false

func init() -> void:
	if !OS.is_debug_build():
		if discord_rpc == null:
			discord_rpc = DiscordRPC.new()
			
			discord_rpc.connect("rpc_ready", self, "_on_ready")
			discord_rpc.connect("rpc_error", self, "_on_error")
			
			add_child(discord_rpc)
			
			discord_rpc.establish_connection(application_id)

func _on_ready(user: Dictionary) -> void:
	print("Discord RPC Ready")
	print("Client username: ", user["username"])
	
	update_presence("Starting up the game.")

func _on_error(error: int) -> void:
	print("RPC Connection ERROR: ", error)

func update_presence(details: String, state: String = "",
			small_image_key: String = "", small_image_text: String = "",
			large_image_key: String = "logo", large_image_text: String = "Leather Engine",
			start_time: int = OS.get_unix_time(), end_time: int = 0):
	presence.details = details
	presence.state = state
	
	presence.small_image_key = small_image_key
	presence.small_image_text = small_image_text
	
	presence.large_image_key = large_image_key
	presence.large_image_text = large_image_text
	
	if is_instance_valid(discord_rpc) and discord_rpc.is_connected_to_client():
		discord_rpc.get_module("RichPresence").update_presence(presence)
	elif !is_instance_valid(discord_rpc) and debug_printing:
		print("----------")
		print("Updated Presence Debug:")
		
		print("Details: " + details)
		
		if state != "":
			print("State: " + state)
		
		if small_image_key != "":
			print("Small Key: " + small_image_key)
			print("Small Text: " + small_image_text)
		
		if large_image_key != "logo":
			print("Large Key: " + large_image_key)
			print("Large Text: " + large_image_text)
