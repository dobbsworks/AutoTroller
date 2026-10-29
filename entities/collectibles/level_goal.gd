extends Node2D
@onready var end_icon: Sprite2D = %EndIcon
const LEVEL_VICTORY_SCREEN = preload("res://ui/level_victory_screen.tscn")
var isActive = true

func _ready() -> void:
	end_icon.region_rect = GameState.getGoalRegionRect()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if !isActive: return
	isActive = false
	var newScene = LEVEL_VICTORY_SCREEN.instantiate()
	get_parent().add_sibling(newScene)
