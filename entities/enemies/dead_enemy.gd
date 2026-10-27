extends CharacterBody2D


func _ready() -> void:
	velocity.y = -100.0
	velocity.x = randf_range(-1.0, 1.0) * 200.0
	
	await get_tree().create_timer(2.0).timeout
	queue_free()
	

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	move_and_slide()
