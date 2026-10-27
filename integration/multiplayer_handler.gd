extends Node
@onready var integration_service: Node = $IntegrationService
@onready var cpu_chatters: Node = $CpuChatters
signal on_new_chatter(chatter: Chatter)

var chatters: Array[Chatter] = []
var spawnCommands: Array[SpawnCommand]
var isActive = false

func _ready() -> void:
	load_spawn_commands()
	integration_service.on_chat_received.connect(on_chat_received)

func _process(delta: float) -> void:
	pass


func on_chat_received(username: String, message_text: String, data: Dictionary, isCpu: bool = false):
	if !isActive: return
	var chatter = getOrCreateChatter(username, isCpu)
	
	if chatter.spawnQueue.size() == 0:
		for spawnCommand in spawnCommands:
			if spawnCommand.cost > chatter.points: 
				chatter.on_too_poor.emit()
				continue
			var relevantText = message_text.replace("!","").strip_edges().to_lower()
			if spawnCommand.commands.has(relevantText):
				# Good to go! Queue it up!
				chatter.points -= spawnCommand.cost
				chatter.isActive = true
				for i in range(spawnCommand.numberSpawned):
					chatter.spawnQueue.append(spawnCommand.spawnedObject)
	
	
func attemptSpawn(potentialSpawnables: Array[PackedScene]) -> PackedScene:
	for potentialSpawnable in potentialSpawnables:
		var c = chatters.filter(func(a: Chatter): return a.spawnQueue.has(potentialSpawnable))
		if c.size() == 0: continue
		c.sort_custom(func(a,b): return a.spawnQueue.size() > b.spawnQueue.size())
		var spawningChatter: Chatter = c[0]
		spawningChatter.spawnQueue.erase(potentialSpawnable)
		return potentialSpawnable
	return null
	
	
func getOrCreateChatter(username: String, isCpu: bool) -> Chatter:
	var chatterIndex = chatters.find_custom(func(a: Chatter): return a.username == username && a.isCpu == isCpu)
	if chatterIndex == -1:
		var chatter = Chatter.new(username, isCpu)
		chatters.append(chatter)
		on_new_chatter.emit(chatter)
		return chatter
	return chatters[chatterIndex]

func load_spawn_commands():
	var directory = "res://globals/SpawnCommands/"
	var dir = DirAccess.open(directory)
	dir.list_dir_begin()
	var fileNames = []
	var fileName = dir.get_next()
	while fileName != "":
		if fileName.ends_with(".tres"):
			fileNames.append(directory.path_join(fileName))
		fileName = dir.get_next()
	for fileName1 in fileNames:
		spawnCommands.append(load(fileName1))


func handle_cpu_chat(username: String, message_text: String, data: Dictionary):
	on_chat_received(username, message_text, data, true)
