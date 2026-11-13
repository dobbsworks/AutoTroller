extends Node2D
@onready var coins_count: Label = %CoinsCount
@onready var death_count: Label = %DeathCount
@onready var fruit_count: Label = %FruitCount
@onready var grid_container: GridContainer = %GridContainer

@onready var drum: AudioStreamPlayer = $Drum

@onready var continueLabel: Label = %Continue
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var control: Control = $CanvasLayer/Control
@onready var victory: RichTextLabel = $CanvasLayer/Control/Victory
@onready var image_dead: Sprite2D = $CanvasLayer/Control/Image/ImageDead
@onready var image_thumbs_up: Sprite2D = $CanvasLayer/Control/Image/ImageThumbsUp
@onready var image_throne: Sprite2D = $CanvasLayer/Control/Image/ImageThrone

@onready var chat_unlock: Control = $CanvasLayer/Control/ChatUnlock
@onready var unlock_name: Label = $CanvasLayer/Control/ChatUnlock/UnlockName
@onready var unlock_texture: TextureRect = $CanvasLayer/Control/ChatUnlock/UnlockTexture
@onready var defeat_1804i: AudioStreamPlayer = $Defeat1804i
@onready var victory_2504i: AudioStreamPlayer = $Victory2504i

var levelOptions: Array[LevelDefinition] = []
var readyToContinue = false
var readyToExit = false

@export var isFinal = false
@export var isDefeat = false

func _ready():
	MultiplayerHandler.isActive = false
	%LevelSign.visible = false
	var levelMusic: AudioStreamPlayer = GameState.shared.levelMusic
	if levelMusic: levelMusic.stop()
	
	if isDefeat:
		defeat_1804i.play()
	else:
		victory_2504i.play()
	
	chat_unlock.visible = false
	isFinal = GameState.stagesPerRound == GameState.round.currentStage && !isDefeat
	image_dead.visible = isDefeat
	image_thumbs_up.visible = false #!isDefeat && !isFinal
	image_throne.visible = isFinal
	fruit_count.text = str(GameState.round.currentStage - (1 if isDefeat else 0))
	
	if isFinal:
		animation_player.play("victory")
		animation_player.queue("init")
		victory.text = "[wave amp=50.0 freq=5.0 connected=1]VICTORY![/wave]"
		coins_count.text = str(GameState.round.totalCoins)
		death_count.text = str(GameState.round.deaths)
	elif isDefeat:
		victory.text = "Defeat..."
		animation_player.play("defeat")
		animation_player.queue("init")
		coins_count.text = str(GameState.round.totalCoins)
		death_count.text = str(GameState.round.deaths)
	else:
		animation_player.play("levelDone")
		animation_player.queue("init")
		animation_player.queue("revealMap")
		coins_count.text = str(GameState.stage.coinsThisStage)
		death_count.text = str(GameState.stage.deathsThisStage)
		levelOptions = LevelManager.getDefinitionOptions(GameState.round.currentStage + 1)
		%AltPath.visible = levelOptions.size() > 1
		%LevelNameLabel.text = levelOptions[0].name
		%GimmickLabel.text = ""
		%HiddenLevelText.visible = levelOptions.size() > 1
		if levelOptions[0].description.length() > 0:
			%GimmickLabel.text = "CAUTION! " + levelOptions[0].description
			
		
		
	
	for child in grid_container.get_children():
		child.modulate = Color.TRANSPARENT
	queueLabels()
	
func queueLabels():
	await get_tree().create_timer(0.5).timeout
	if GameState.stage.levelScene: GameState.stage.levelScene.queue_free()
	await get_tree().create_timer(1.0).timeout
	for child in grid_container.get_children():
		await get_tree().create_timer(0.3).timeout
		drum.play()
		child.modulate = Color.WHITE
	fruit_count.modulate = Color.WHITE
	
	
	if !isFinal && !isDefeat:
		%PlayerMove.play("centerToSign")
		await %PlayerMove.animation_finished
		%LevelSign.visible = true
		readyToContinue = true
	else:
		#unlockItem()
		await get_tree().create_timer(1.5).timeout
		readyToExit = true
	
	#continueLabel.modulate = Color.WHITE
	#readyToContinue = true




func _process(delta: float) -> void:
	if readyToContinue:
		var chooseRight = Input.is_action_just_pressed("right")
		var chooseDown = Input.is_action_just_pressed("down") && levelOptions.size() > 1
		if chooseRight:
			LevelManager.setSelected(GameState.round.currentStage + 1, 0)
			%PlayerMove.play("signToRight")
		if chooseDown:
			LevelManager.setSelected(GameState.round.currentStage + 1, 1)
			flipSign(levelOptions[1])
			%PlayerMove.play("signToDown")
		if chooseRight || chooseDown:
			%SignContinueLabel.text = "Heading towards..."
			%HiddenLevelText.modulate = Color.TRANSPARENT
			readyToContinue = false
			await get_tree().create_timer(0.5).timeout
			animation_player.play_backwards("revealMap")
			await get_tree().create_timer(0.5).timeout
			unlockItem()
	if readyToExit:
		%Continue.visible = true
		if Input.is_action_just_pressed("jump"):
			readyToExit = false
			next()

func next():
	var t = create_tween().tween_property(control, "position:x", 1600, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	var t2 = create_tween().tween_property(victory, "modulate", Color.TRANSPARENT, 1.0)
	%cam.queue_free()
	animation_player.play_backwards("init")
	
	if isFinal || isDefeat:
		GameState.resetGame()
		MultiplayerHandler.isActive = false
		get_tree().change_scene_to_file("res://main.tscn")
	else:
		# prep next level
		GameState.round.currentStage += 1
		GameState.createNewLevel()
	defeat_1804i.stop()
	victory_2504i.stop()
	await get_tree().create_timer(1.0).timeout
	queue_free()
	
func unlockItem():
	%GridContainer.visible = false
	var lockedItems = MultiplayerHandler.spawnCommands.filter(func(a:SpawnCommand): return !a.isActive)
	if lockedItems.size():
		var unlocked: SpawnCommand = lockedItems.pick_random()
		unlocked.isActive = true
		unlock_texture.texture = unlocked.viewport.get_texture()
		unlock_name.text = unlocked.name
		%EnemyDescription.text = unlocked.description
		chat_unlock.visible = true
		drum.play()
		
		await get_tree().create_timer(1.0).timeout
		readyToExit = true

func flipSign(newLevelDef: LevelDefinition):
	for i in range(2):
		create_tween().tween_property(%LevelSign, "scale:x", -1, 0.1 * i)
		await get_tree().create_timer(0.1 * i * 0.5).timeout
		if i == 1:
			%LevelNameLabel.text = newLevelDef.name
			%GimmickLabel.text = ""
			if newLevelDef.description.length() > 0:
				%GimmickLabel.text = "CAUTION! " + newLevelDef.description
		await get_tree().create_timer(0.1 * i * 0.5).timeout
		create_tween().tween_property(%LevelSign, "scale:x", 1, 0.1 * i)
		await get_tree().create_timer(0.1 * i).timeout
	
		
