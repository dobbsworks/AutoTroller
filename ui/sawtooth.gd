
@tool

extends Node2D
@onready var polygon_2d: Node2D = $Node2D

@export var speed = 100.0

func _process(delta: float) -> void:
	polygon_2d.position.x -= speed * delta
	polygon_2d.position.x = fposmod(polygon_2d.position.x, 100.0) - 100.0
