extends Node
@onready var integration_service: Node = $IntegrationService
@onready var cpu_chatters: Node = $CpuChatters
@export var spawnCommands: Array[SpawnCommand] = []

signal on_new_chatter(chatter: Chatter)

var chatters: Array[Chatter] = []
var isActive = false

func _ready() -> void:
	load_spawn_commands()
	integration_service.on_chat_received.connect(on_chat_received)

func _process(delta: float) -> void:
	pass


func Reset():
	chatters = []
	UiLayer.reset()
	
	
func raw_chat_receive(username: String, message_text: String, data: Dictionary):
	on_chat_received(username, message_text, data, "Twitch")
	

func on_chat_received(username: String, message_text: String, data: Dictionary, platform: String):
	if !isActive: return
	var chatter = getOrCreateChatter(username, platform)
		
	if chatter.spawnQueue.size() == 0:
		for spawnCommand in spawnCommands:
			if !spawnCommand.isActive: continue
			if spawnCommand.cost > chatter.points: 
				chatter.on_too_poor.emit()
				continue
			var relevantText = message_text.replace("!","").strip_edges().to_lower().split(" ")[0]
			if spawnCommand.commands.has(relevantText):
				# Good to go! Queue it up!
				chatter.points -= spawnCommand.cost
				chatter.isActive = true
				chatter.on_update_queue.emit(spawnCommand)
				for i in range(spawnCommand.numberSpawned):
					chatter.spawnQueue.append(spawnCommand.spawnedObject)
	
	
func attemptSpawn(potentialSpawnables: Array[PackedScene]) -> SpawnResult:
	for potentialSpawnable in potentialSpawnables:
		var c: Array[Chatter] = chatters.filter(func(a: Chatter): return a.spawnQueue.has(potentialSpawnable))
		if c.size() == 0: continue
		
		var spawningChatter: Chatter = c[0]
		var humanSpawners = c.filter(func(a: Chatter): return a.platform != "Bot")
		if humanSpawners.size() > 0:
			spawningChatter = humanSpawners[0]
		
		spawningChatter.spawnQueue.erase(potentialSpawnable)
		if spawningChatter.spawnQueue.size() == 0:
			spawningChatter.on_update_queue.emit(null)
			# move to end
			chatters.erase(spawningChatter)
			chatters.append(spawningChatter)
		var ret = SpawnResult.new()
		ret.chatter = spawningChatter
		ret.spawnable = potentialSpawnable
		
		# handle level spawn swaps
		var levelDef: LevelDefinition = GameState.shared.levelDefinition
		if levelDef:
			for spawnSwap: SpawnSwap in levelDef.spawnSwaps:
				if spawnSwap.from == ret.spawnable:
					ret.spawnable = spawnSwap.to
		
		return ret
	return null
	
	
func getOrCreateChatter(username: String, platform: String) -> Chatter:
	var chatterIndex = chatters.find_custom(func(a: Chatter): return a.username == username && a.platform == platform)
	if chatterIndex == -1:
		var chatter = Chatter.new(username, platform)
		chatters.append(chatter)
		on_new_chatter.emit(chatter)
		return chatter
	return chatters[chatterIndex]

func load_spawn_commands():
	for spawnCommand in spawnCommands:
		var vp := SubViewport.new()
		vp.transparent_bg = true
		vp.size = Vector2i(16,16)
		var tempNode = spawnCommand.spawnedObject.instantiate()
		tempNode.position = Vector2(8,8)
		if "isDummy" in tempNode: tempNode.isDummy = true
		vp.add_child(tempNode)
		add_child(vp)
		spawnCommand.viewport = vp



func handle_cpu_chat(username: String, message_text: String, data: Dictionary):
	#return
	on_chat_received(username, message_text, data, "Bot")
