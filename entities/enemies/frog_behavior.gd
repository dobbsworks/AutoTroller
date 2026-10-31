extends Node
@onready var sprite_2d: Sprite2D = $"../Sprite/Sprite2D"
@onready var sprite_2d_2: Sprite2D = $"../Sprite/Sprite2D2"
@onready var frog_enemy: Enemy = $".."

func _process(delta: float) -> void:
	sprite_2d.visible = frog_enemy.is_on_floor()
	sprite_2d_2.visible = !frog_enemy.is_on_floor()
