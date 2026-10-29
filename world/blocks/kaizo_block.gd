extends CharacterBody2D
@onready var area_collider: CollisionShape2D = $Area2D/AreaCollider
const SOLID_BLOCK = preload("res://world/blocks/solid_block.tscn")


var player: CharacterBody2D

func _ready() -> void:
	get_parent().onPlayerHitFromBelow.connect(onHit)

	


func onHit(player: CharacterBody2D) -> void:
	var newBlock = SOLID_BLOCK.instantiate()
	get_parent().add_sibling(newBlock)
	newBlock.global_position = global_position
	newBlock.get_node("AnimationPlayer").play("pop-up")
	get_parent().queue_free()
	
