extends Node
class_name Chatter

var isActive = false
var username = ""
var platform = ""
var points = 0
var spawnQueue: Array[PackedScene] = []

signal on_too_poor()
signal on_update_queue(spawnCommand: SpawnCommand)

func _init(username: String, platform: String):
	self.username = username
	self.platform = platform
