extends CharacterBody2D
class_name Enemy
@onready var sprite: Node2D = $Sprite
const DEAD_ENEMY = preload("res://entities/enemies/DeadEnemy.tscn")


@export var hurtOnContact = true
@export var canJumpOn = false


@export_category("Movement")
@export var gravityRatio = 1.0

@export var horizontalAccel = 1000.0
@export var horizMaxSpeed = 40.0
@export var reflectOnWall = true
@export var turnAtEdges = false

@export var jumps = false
@export var jumpStrength = 300.0


var horizontalDirection = -1
var age = 0.0
var isGroundLeft = false
var isGroundRight = false


func _physics_process(delta: float) -> void:
	age += delta
	
	if not is_on_floor():
		velocity += get_gravity() * delta * gravityRatio

	if is_on_floor() && turnAtEdges:
		if horizontalDirection == -1 && !isGroundLeft: horizontalDirection = 1
		if horizontalDirection == 1 && !isGroundRight: horizontalDirection = -1
		
	if jumps && is_on_floor():
		velocity.y = -jumpStrength
		
	var targetHorizVelocity = horizMaxSpeed * horizontalDirection
	velocity.x = move_toward(velocity.x, targetHorizVelocity, horizontalAccel)
	move_and_slide()
	sprite.scale.x = horizontalDirection
	if reflectOnWall && is_on_wall() && velocity.x == 0.0:
		horizontalDirection *= -1
		


func kill(): 
	var corpse = DEAD_ENEMY.instantiate()
	add_sibling(corpse)
	corpse.global_position = global_position
	sprite.reparent(corpse)
	corpse.rotation = PI
	queue_free()


func _on_left_ground_check_body_entered(body: Node2D) -> void:
	isGroundLeft = true
func _on_left_ground_check_body_exited(body: Node2D) -> void:
	isGroundLeft = false
func _on_right_ground_check_body_entered(body: Node2D) -> void:
	isGroundRight = true
func _on_right_ground_check_body_exited(body: Node2D) -> void:
	isGroundRight = false
