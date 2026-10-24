extends CharacterBody2D


@export var maxRunSpeed = 200.0
@export var maxWalkSpeed = 100.0
@export var horizAccel = 600.0
@export var slowDownHorizAccel = 600.0
@export var JUMP_VELOCITY = -360.0
@export var maxFallSpeed = 300.0

@onready var player_sprite: Node2D = $PlayerSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var facing = 1

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		var fallAccel = get_gravity().y * delta
		if !Input.is_action_pressed("jump"):
			fallAccel *= 2
		velocity.y = move_toward(velocity.y, maxFallSpeed, fallAccel)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		var maxSpeed = maxRunSpeed if Input.is_action_pressed("run") else maxWalkSpeed
		velocity.x = move_toward(velocity.x, direction * maxSpeed, horizAccel * delta)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, slowDownHorizAccel * delta)

	move_and_slide()
	updateFacing()
	updateAnimation()
	#position.y = -100.0
	if (position.y) > 0:
		position.y = -100.0

func updateFacing():
	var direction := Input.get_axis("left", "right")
	if is_on_floor():
		if direction > 0:
			facing = 1
		if direction < 0:
			facing = -1
	else:
		if direction == 1: 
			facing = 1
		if direction == -1: 
			facing = -1
	player_sprite.scale.x = facing

func updateAnimation():
	animation_player.speed_scale = 1.0
	var targetAnimation = "idle"
	var inputDirection := Input.get_axis("left", "right")
	if inputDirection != 0:
		targetAnimation = "walk"
		
	if !is_on_floor():
		if velocity.y > 0:
			targetAnimation = "jumpdown"
		else:
			targetAnimation = "jumpup"
		
	if targetAnimation == "walk":
		animation_player.speed_scale = abs(velocity.x / 100.0)
		
	var currentAnimation = animation_player.current_animation
	if currentAnimation != targetAnimation:
		animation_player.play("RESET")
		
		animation_player.queue(targetAnimation)
		


func _on_squish_detector_body_entered(body: Node2D) -> void:
	print("SQUISH DETECTED")


func _on_collection_and_enemy_area_body_entered(body: Node2D) -> void:
	print("TEST")
