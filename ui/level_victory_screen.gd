extends Node2D
@onready var coins: Label = %Coins
@onready var coins_count: Label = %CoinsCount
@onready var deaths: Label = %Deaths
@onready var death_count: Label = %DeathCount
@onready var fruits: Label = %Fruits
@onready var fruit_count: Label = %FruitCount

@onready var drum: AudioStreamPlayer = $Drum

@onready var continueLabel: Label = %Continue
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var control: Control = $CanvasLayer/Control
@onready var victory: RichTextLabel = $CanvasLayer/Control/Victory
@onready var image_dead: Sprite2D = $CanvasLayer/Control/Image/ImageDead
@onready var image_thumbs_up: Sprite2D = $CanvasLayer/Control/Image/ImageThumbsUp
@onready var image_throne: Sprite2D = $CanvasLayer/Control/Image/ImageThrone


var readyToContinue = false

@export var isFinal = false
@export var isDefeat = false

func _ready():
	isFinal = GameState.stagesPerRound == GameState.round.currentStage && !isDefeat
	image_dead.visible = isDefeat
	image_thumbs_up.visible = !isDefeat && !isFinal
	image_throne.visible = isFinal
	fruit_count.text = str(GameState.round.currentStage)
	
	if isFinal:
		animation_player.play("victory")
		victory.text = "[wave amp=50.0 freq=5.0 connected=1]VICTORY![/wave]"
		coins_count.text = str(GameState.round.coins)
		death_count.text = str(GameState.round.deaths)
	elif isDefeat:
		victory.text = "Defeat..."
		animation_player.play("defeat")
		coins_count.text = str(GameState.round.coins)
		death_count.text = str(GameState.round.deaths)
	else:
		animation_player.play("levelDone")
		coins_count.text = str(GameState.stage.coinsThisStage)
		death_count.text = str(GameState.stage.deathsThisStage)
	animation_player.queue("init")
	coins.modulate = Color.TRANSPARENT
	coins_count.modulate = Color.TRANSPARENT
	deaths.modulate = Color.TRANSPARENT
	death_count.modulate = Color.TRANSPARENT
	fruits.modulate = Color.TRANSPARENT
	fruit_count.modulate = Color.TRANSPARENT
	continueLabel.modulate = Color.TRANSPARENT
	queueLabels()
	
func queueLabels():
	await get_tree().create_timer(1.5).timeout
	drum.play()
	coins.modulate = Color.WHITE
	await get_tree().create_timer(0.3).timeout
	drum.play()
	coins_count.modulate = Color.WHITE
	await get_tree().create_timer(0.3).timeout
	drum.play()
	deaths.modulate = Color.WHITE
	await get_tree().create_timer(0.3).timeout
	drum.play()
	death_count.modulate = Color.WHITE
	await get_tree().create_timer(0.3).timeout
	drum.play()
	fruits.modulate = Color.WHITE
	await get_tree().create_timer(0.3).timeout
	drum.play()
	fruit_count.modulate = Color.WHITE
	await get_tree().create_timer(0.3).timeout
	
	await get_tree().create_timer(0.5).timeout
	continueLabel.modulate = Color.WHITE
	readyToContinue = true


func _process(delta: float) -> void:
	if readyToContinue && Input.is_action_just_pressed("jump"):
		readyToContinue = false
		next()


func next():
	var t = create_tween().tween_property(control, "position:x", 1600, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	var t2 = create_tween().tween_property(victory, "modulate", Color.TRANSPARENT, 1.0)
	animation_player.play_backwards("init")
	GameState.stage.levelScene.queue_free()
	
	if isFinal || isDefeat:
		GameState.resetGame()
		MultiplayerHandler.isActive = false
		get_tree().change_scene_to_file("res://main.tscn")
	else:
		# prep next level
		GameState.round.currentStage += 1
		GameState.createNewLevel()
	await get_tree().create_timer(1.0).timeout
	queue_free()
	
