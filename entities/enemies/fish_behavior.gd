extends Node

@onready var green_fish_enemy: Enemy = $".."
@export var follows = false

func _process(delta: float) -> void:
	if green_fish_enemy.isDummy: return
	
	if green_fish_enemy.global_position.y > 10:
		green_fish_enemy.velocity.y = -green_fish_enemy.jumpStrength
		
	if follows:
		if GameState.shared.player.global_position.x < green_fish_enemy.global_position.x:
			green_fish_enemy.horizontalDirection = -1
		else:
			green_fish_enemy.horizontalDirection = 1
