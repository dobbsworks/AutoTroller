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
var isCrouching = false

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		var fallAccel = get_gravity().y * delta
		if !Input.is_action_pressed("jump"):
			fallAccel *= 2
		velocity.y = move_toward(velocity.y, maxFallSpeed, fallAccel)

	if Input.is_action_just_pressed("jump") && is_on_floor():
		Jump()
		
	if Input.is_action_pressed("down"):
		if is_on_floor():
			isCrouching = true
	else:
		isCrouching = false
		

	var direction := Input.get_axis("left", "right")
	if direction && !(isCrouching && is_on_floor()):
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
		onKilled()

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
	if Input.is_action_pressed("up") && is_on_floor():
		targetAnimation = "lookup"
	var inputDirection := Input.get_axis("left", "right")
	if inputDirection != 0:
		targetAnimation = "walk"
		
	if !is_on_floor():
		if velocity.y > 0:
			targetAnimation = "jumpdown"
		else:
			targetAnimation = "jumpup"
			
	if isCrouching:
		targetAnimation = "crouch"
		
	if targetAnimation == "walk":
		animation_player.speed_scale = abs(velocity.x / 100.0)
		
	var currentAnimation = animation_player.current_animation
	if currentAnimation != targetAnimation:
		animation_player.play("RESET")
		
		animation_player.queue(targetAnimation)
		
		
func onKilled():
	position.y = -100.0
	
	
func BounceUp():
	velocity.y = JUMP_VELOCITY
func Jump():
	velocity.y = JUMP_VELOCITY
	


func _on_squish_detector_body_entered(body: Node2D) -> void:
	print("SQUISH DETECTED")


func _on_collection_and_enemy_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		if body.canJumpOn:
			var enemyCollider: CollisionShape2D = body.get_node("CollisionShape2D")
			var enemyTopGlobalY = enemyCollider.global_position.y - enemyCollider.shape.get_rect().size.y / 2.0
			var playerCollider: CollisionShape2D = get_node("CollisionShape2D")
			var playerBottomY = playerCollider.global_position.y + playerCollider.shape.get_rect().size.y / 2.0
			var isLandingOnTop = playerBottomY - 1.0 - velocity.y * get_process_delta_time() < enemyTopGlobalY
			if isLandingOnTop:
				body.kill()
				BounceUp()
				return
		onKilled()
