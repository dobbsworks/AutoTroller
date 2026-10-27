extends Node
@onready var multiplayer_handler: Node = $".."


@export var secondsPerChatPerChatter = 5.0
var timeUntilNextChat = 0.0
var currentChatNames = []

func _process(delta: float) -> void:
	var cpuChatterCount = SaveManager.saveData.botCount
	timeUntilNextChat = move_toward(timeUntilNextChat, 0.0, delta)
	if timeUntilNextChat == 0.0 && cpuChatterCount > 0:
		timeUntilNextChat = secondsPerChatPerChatter / cpuChatterCount
		generateAndSendCpuChatMessage()
	
	
func generateAndSendCpuChatMessage():
	var cpuChatterCount = SaveManager.saveData.botCount
	var chatNameIndex = randi_range(0, cpuChatterCount - 1)
	var chatterName = ""
	if currentChatNames.size() <= chatNameIndex:
		chatterName = get_fake_name()
		currentChatNames.append(chatterName)
	else:
		chatterName = currentChatNames[chatNameIndex]
		
	var command = MultiplayerHandler.spawnCommands.pick_random().commands.pick_random()
	send_chat(chatterName, "coin", {})
	

func send_chat(username: String, message_text: String, data: Dictionary):
	multiplayer_handler.handle_cpu_chat(username, message_text, data)


func get_fake_name() -> String:
	var prefixes = [
		"Giant", 
		"Tiny", 
		"Red", 
		"Orange", 
		"Squeaky",
		"Yellow", 
		"Green", 
		"Blue", 
		"Purple", 
		"Golden",
		"Amazing", 
		"Terrible", 
		"Freaky", 
		"Salty", 
		"Sneaky", 
		"Loud",
		"Poison",
		"Silent",
		"Dark",
		"Bright",
		"Hungry",
		"Happy",
		"Clumsy",
		"Chatty",
		"Careful",
		"Ambitious",
		"Skill",
		"Grumpy",
		"Lost",
		"Lucky",
		"Pointy",
		"Sharp",
		"Dull",
		"Stretchy",
		"Tall",
		"Short",
		"Solid",
		"Doctor",
		"Fake",
		"Real",
		"Quick",
		"Speedy",
		"Falling",
		"Plush",
		"Feathered",
		"Scary",
		"Friendly",
		"Neutral",
		"Sunny",
		"Rainy",
		"Captain",
		"Rocky",
		"Grassy",
		"Windy",
		"Smoky",
		"Poor",
		"Flying",
		"Electric",
		"Liquid",
		"Sour",
		"Bitter",
		"Sweet",
		"Fancy",
		"Normal",
		"Regular",
		"Robotic",
		"Sharp",
		"Chirpy",
		"Hot",
		"Warm",
		"Cold",
		"Chilly",
		"Medium",
		"Mystery",
		"Rotten",
		"Famous",
		"Charging",
		"Epic",
		"Random",
	]
	var nouns = [
		"Snail",
		"Horse",
		"Dragon",
		"Piggle",
		"Cricket",
		"Jelly",
		"Bee",
		"Shrub",
		"Goat",
		"Mouse",
		"Cat",
		"Dog",
		"Poodle",
		"Cow",
		"Donkey",
		"Number",
		"Barrel",
		"Lizard",
		"Apple",
		"Banana",
		"Coconut",
		"Cake",
		"Pastry",
		"Planet",
		"Meteor",
		"Gear",
		"Frog",
		"Pocket",
		"Spring",
		"Summer",
		"Snowman",
		"Penguin",
		"Bird",
		"Bug",
		"Worm",
		"Tanuki",
		"Thing",
		"Mystery",
		"Object",
		"Coffee",
		"Bread",
		"Sword",
		"Dress",
		"Elephant",
		"Armadillo",
		"Bomb",
		"Chatter",
		"Photon",
		"Dev",
	]
	
	var prefix: String = prefixes.pick_random()
	var noun: String = nouns.pick_random()
	var randNum: String = str(randi_range(0, [9, 99, 999].pick_random()))
	if randf() < 0.4: randNum = "_" + randNum
	
	return [
		prefix.to_lower() + noun,
		prefix + noun,
		prefix + noun + randNum,
		prefix.to_lower() + randNum,
		noun + randNum,
	].pick_random()
	
