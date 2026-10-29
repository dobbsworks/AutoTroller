extends CanvasLayer
@onready var chatter_vbox: VBoxContainer = %ChatterVbox
@onready var chatter_scroll_box: ScrollContainer = %ChatterScrollBox
@onready var coin_count: Label = %CoinCount
@onready var life_count: Label = %LifeCount
@onready var hud_spawn_container: HBoxContainer = %HudSpawnContainer
@onready var player_path_follow: PathFollow2D = %PlayerPathFollow
@onready var end_icon: Sprite2D = %EndIcon

const CHATTER_ROW = preload("res://ui/chatter_row.tscn")
const HUD_SPAWN_ITEM = preload("res://ui/components/hud_spawn_item.tscn")


func _ready() -> void:
	MultiplayerHandler.isActive = true
	for chatter in MultiplayerHandler.chatters:
		on_new_chatter(chatter)
	MultiplayerHandler.on_new_chatter.connect(on_new_chatter)
	setupSpawnMenuHud()
	
func reset():
	for child in chatter_vbox.get_children():
		child.queue_free()

func _process(delta: float) -> void:
	visible = MultiplayerHandler.isActive
	coin_count.text = ("%02d" % GameState.round.coins)
	life_count.text = ("%02d" % GameState.round.lives)
	
	if GameState.shared.player:
		var playerProgressRatio = GameState.shared.player.position.x / GameState.stage.goalDistance
		playerProgressRatio = clampf(playerProgressRatio, 0, 1.0)
		player_path_follow.progress_ratio = playerProgressRatio
		end_icon.region_rect = GameState.getGoalRegionRect()
	else: 
		player_path_follow.progress_ratio = 0.0

func on_new_chatter(chatter: Chatter):
	var chatterRow = CHATTER_ROW.instantiate()
	chatterRow.set_chatter(chatter)
	chatter_vbox.add_child(chatterRow)

func setupSpawnMenuHud():
	for spawnCommand: SpawnCommand in MultiplayerHandler.spawnCommands:
		var hudItem = HUD_SPAWN_ITEM.instantiate()
		hud_spawn_container.add_child(hudItem)
		hudItem.setup(spawnCommand)
