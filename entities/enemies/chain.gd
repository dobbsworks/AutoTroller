extends Node2D


@export var endItems: Array[Node2D] = []

@export var rotationSpeed = 1.0
@export var radius = 16.0 * 4.0
var age = 0.0

func _process(delta: float) -> void:
	if get_parent().isDummy: 
		$"../Sprite".scale = Vector2.ONE * 0.5

		return
	age += delta
	
	var theta = age * rotationSpeed
	var endPoint = Vector2(cos(theta), sin(theta)) * radius
	for item in endItems:
		item.position = endPoint
		
	var numLinks = get_child_count()
	for chainLink in get_children():
		chainLink.position = endPoint * (chainLink.get_index() + 1) / (numLinks + 1)
