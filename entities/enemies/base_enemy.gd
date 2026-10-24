extends CharacterBody2D
class_name Enemy

const SPEED = 100.0

@export var hurtOnContact = true
@export var canJumpOn = false


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func kill(): 
	
	queue_free()
