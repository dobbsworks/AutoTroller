extends CharacterBody2D


@export var maxRunSpeed = 200.0
@export var maxWalkSpeed = 100.0
@export var horizAccel = 600.0
@export var slowDownHorizAccel = 600.0
@export var JUMP_VELOCITY = -360.0
@export var maxFallSpeed = 300.0
@onready var cloud: Node2D = $PlayerSprite/Cloud

@onready var player_sprite: Node2D = $PlayerSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const KAIZO_INIT = preload("res://world/blocks/kaizo_init.tscn")
const KAIZO_BLOCK = preload("res://world/blocks/kaizo_block.tscn")
const LEVEL_VICTORY_SCREEN = preload("res://ui/level_victory_screen.tscn")

var facing = 1
var isCrouching = false
var respawnTimer = 0.0
var interactedWithEnemyThisFrame = false

func _ready() -> void:
	GameState.shared.player = self

func _physics_process(delta: float) -> void:
	interactedWithEnemyThisFrame = false
	if respawnTimer > 0.0:
		respawnTimer = move_toward(respawnTimer, 0.0, delta)
		velocity.y = 30.0
		velocity.x = GameState.shared.camera.speed
	
	if respawnTimer < 4.0 && respawnTimer > 0.0:
		if Input.is_action_just_pressed("jump"):
			respawnTimer = 0.0
			Jump()
	
	else:
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
	handleKaizos()
	
	move_and_slide()
	updateFacing()
	updateAnimation()
	if (position.y) > 10:
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
	
	cloud.visible = respawnTimer > 0.0
	if respawnTimer > 0.0:
		visible = fposmod(respawnTimer, 0.4) > 0.2
	else: 
		visible = true
	
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
		
	if respawnTimer > 0.0:
		targetAnimation = "idle"
		
	var currentAnimation = animation_player.current_animation
	if currentAnimation != targetAnimation:
		animation_player.play("RESET")
		
		animation_player.queue(targetAnimation)
		
		
func onKilled():
	if respawnTimer > 0.0: return
	GameState.round.lives -= 1
	GameState.round.deaths += 1
	GameState.stage.deathsThisStage += 1
	
	respawnTimer = 5.0
	GameState.stage.levelScene.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(0.5).timeout
	GameState.stage.levelScene.process_mode = Node.PROCESS_MODE_INHERIT
	
	if GameState.round.lives == 0:
		var newScene = LEVEL_VICTORY_SCREEN.instantiate()
		newScene.isDefeat = true
		get_parent().add_sibling(newScene)
		self.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		position.y = -250.0
		global_position.x = GameState.shared.camera.global_position.x - 32
		
		
	
func BounceUp():
	velocity.y = JUMP_VELOCITY
func Jump():
	velocity.y = JUMP_VELOCITY
	


func _on_squish_detector_body_entered(body: Node2D) -> void:
	onKilled()


func _on_collection_and_enemy_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		if interactedWithEnemyThisFrame: return # prevent double-sprite
		if respawnTimer > 0.0: return
		if body.canJumpOn:
			var enemyCollider: CollisionShape2D = body.get_node("CollisionShape2D")
			var enemyTopGlobalY = enemyCollider.global_position.y - enemyCollider.shape.get_rect().size.y / 2.0
			var playerCollider: CollisionShape2D = get_node("CollisionShape2D")
			var playerBottomY = playerCollider.global_position.y + playerCollider.shape.get_rect().size.y / 2.0
			var isLandingOnTop = playerBottomY - 1.0 - velocity.y * get_process_delta_time() < enemyTopGlobalY
			if isLandingOnTop:
				body.kill()
				interactedWithEnemyThisFrame = true
				BounceUp()
				return
		onKilled()




func handleKaizos():
	# check if user is jumping up
	if GameState.stage.done: return
	if is_on_floor() || is_on_floor(): return
	if velocity.y >= 0: return
	
	var spawnables: Array[PackedScene] = [KAIZO_INIT]
	var spawnedItem = MultiplayerHandler.attemptSpawn(spawnables)
	if spawnedItem:
		var instantiatedBlock = KAIZO_BLOCK.instantiate()
		add_sibling(instantiatedBlock)
		instantiatedBlock.chatter = spawnedItem.chatter
		instantiatedBlock.global_position = global_position + Vector2(0, -16)
		instantiatedBlock.global_position = snapped(instantiatedBlock.global_position - Vector2(0, 24), Vector2(16, 16)) + Vector2(8, 8)
	
