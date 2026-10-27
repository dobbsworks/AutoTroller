extends Node


var isConnected = false
var isConnecting = false
var isDisconnecting = false
var connectedName = ""

signal on_chat_received(username: String, message_text: String, data: Dictionary)

#
#func _ready() -> void:
	#var connectionName = SaveManager.saveData.username
	#SetupTwitchConnection("dobbsworks")


func SetupTwitchConnection(channelName: String):
	isConnecting = true
	var success: bool = await TwitchService.instance.setup();
	if !success:
		printerr("Twitch Service setup failed.");
		isConnecting = false
		isConnected = false
		return;
	print("Twitch Service successfully set up and authenticated!");
	await on_twitch_ready(channelName);
	
func Unsetup():
	isDisconnecting = true
	await TwitchService.instance.unsetup();
	isDisconnecting = false
	connectedName = ""
	isConnected = false
	
func on_twitch_ready(channelName: String) -> void:
	await subscribe_to_events();
	isConnecting = false
	isConnected = true
	connectedName = channelName
	
func subscribe_to_events() -> void:
	await TwitchService.instance.eventsub.wait_setup();
	var me = await TwitchService.instance.get_current_user();
	TwitchService.instance.subscribe_event(
		TwitchEventsubDefinition.CHANNEL_CHAT_MESSAGE,
		{
			&"broadcaster_user_id": me.id,
			&"user_id": me.id
		}
	);
	TwitchService.instance.subscribe_event(
		TwitchEventsubDefinition.CHANNEL_CHANNEL_POINTS_CUSTOM_REWARD_REDEMPTION_ADD,
		{
			&"broadcaster_user_id": me.id
		}
	);
	TwitchService.instance.eventsub.event.connect(on_eventsub_event);
	
func on_eventsub_event(type: StringName, data: Dictionary):
	if type == "channel.chat.message":
		on_chat_message(data.chatter_user_name, data.message.text, data)
		
func on_chat_message(username: String, message_text: String, data: Dictionary):
	print(username, ": ", message_text)
	on_chat_received.emit(username, message_text, data)
	
	
	
	
	
#channel.chat.message
#{ 
	#"broadcaster_user_id": "203584709", 
	#"broadcaster_user_login": "dobbsworks", 
	#"broadcaster_user_name": "dobbsworks", 
	#"source_broadcaster_user_id": <null>, 
	#"source_broadcaster_user_login": <null>, 
	#"source_broadcaster_user_name": <null>, 
	#"chatter_user_id": "203584709", 
	#"chatter_user_login": "dobbsworks", 
	#"chatter_user_name": "dobbsworks", 
	#"message_id": "01cc90b7-e66b-4d88-a525-cea07e4bfbf5", 
	#"source_message_id": <null>, 
	#"is_source_only": <null>, 
	#"message": { 
		#"text": "test", 
		#"fragments": [
			#{ 
				#"type": "text", 
				#"text": "test", 
				#"cheermote": <null>, 
				#"emote": <null>, 
				#"mention": <null>, 
				#"gif": <null> 
			#}
		#] }, 
		#"color": "#5F9EA0", 
		#"badges": [{ "set_id": "broadcaster", "id": "1", "info": "" }, { "set_id": "subscriber", "id": "12", "info": "82" }], 
		#"source_badges": <null>, 
		#"message_type": "text", 
		#"cheer": <null>, 
		#"reply": <null>, 
		#"channel_points_custom_reward_id": <null>, 
		#"channel_points_animation_id": <null> 
	#}
