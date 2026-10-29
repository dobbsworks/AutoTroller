extends CharacterBody2D
@onready var area_collider: CollisionShape2D = $Area2D/AreaCollider
const SOLID_BLOCK = preload("res://world/blocks/solid_block.tscn")
const USERNAME_POPUP = preload("res://entities/username_popup.tscn")


var player: CharacterBody2D

func _ready() -> void:
	get_parent().onPlayerHitFromBelow.connect(onHit)

	


func onHit(player: CharacterBody2D) -> void:
	if get_parent().chatter:
		var text = USERNAME_POPUP.instantiate()
		get_parent().add_sibling(text)
		text.get_node("Control/Label").text = get_parent().chatter.username
		text.global_position = global_position
	
	var newBlock = SOLID_BLOCK.instantiate()
	get_parent().add_sibling(newBlock)
	newBlock.global_position = global_position
	newBlock.get_node("AnimationPlayer").play("pop-up")
	get_parent().queue_free()
	
