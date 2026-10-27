extends Node
class_name Chatter

var isActive = false
var username = ""
var isCpu = false
var points = 0
var spawnQueue: Array[PackedScene] = []

signal on_too_poor()

func _init(username: String, isCpu: bool):
	self.username = username
	self.isCpu = isCpu
