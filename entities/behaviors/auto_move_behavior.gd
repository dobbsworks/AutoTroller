extends Node


@export_enum("constant", "sine") var horizBehavior = 0
@export_enum("constant", "sine") var vertBehavior = 0

@export var horizSpeed = -4.0

var parent: Node2D
var age = 0
var initialPosition: Vector2
var startAge = 0

func _ready() -> void:
	age = startAge
	var p = get_parent()
	if p is Node2D:
		if 'isDummy' in p:
			if p.isDummy: return
		parent = p

func _process(delta: float) -> void:
	if !parent: return
	if initialPosition == Vector2.ZERO:
		initialPosition = parent.position
		if vertBehavior == 1:
			age -= parent.position.x / 16.0
			if horizBehavior == 1:
				age = startAge
			
	age += delta
	if horizBehavior == 0:
		parent.position.x += horizSpeed * delta
	if horizBehavior == 1:
		parent.position.x = initialPosition.x + cos(age * 2.0) * 16.0
		
	if vertBehavior == 1:
		parent.position.y = initialPosition.y + sin(age * 2.0) * 16.0
