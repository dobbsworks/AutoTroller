extends Node
@onready var sprite_2d: Sprite2D = $"../Sprite/Sprite2D"

var age = 0.0
func _process(delta: float) -> void:
	age += delta
	sprite_2d.scale.x = -1 if fposmod(age, 0.5) > 0.25 else 1
