extends CanvasLayer
@onready var chatter_vbox: VBoxContainer = %ChatterVbox
@onready var chatter_scroll_box: ScrollContainer = %ChatterScrollBox
@onready var coin_count: Label = %CoinCount
@onready var life_count: Label = %LifeCount
@onready var hud_spawn_container: HBoxContainer = %HudSpawnContainer


const CHATTER_ROW = preload("res://ui/chatter_row.tscn")
const HUD_SPAWN_ITEM = preload("res://ui/components/hud_spawn_item.tscn")


func _ready() -> void:
	MultiplayerHandler.isActive = true
	for chatter in MultiplayerHandler.chatters:
		on_new_chatter(chatter)
	MultiplayerHandler.on_new_chatter.connect(on_new_chatter)
	setupSpawnMenuHud()

func _process(delta: float) -> void:
	coin_count.text = ("%02d" % GameState.round.coins)
	life_count.text = ("%02d" % GameState.round.lives)

func on_new_chatter(chatter: Chatter):
	var chatterRow = CHATTER_ROW.instantiate()
	chatterRow.set_chatter(chatter)
	chatter_vbox.add_child(chatterRow)

func setupSpawnMenuHud():
	for spawnCommand: SpawnCommand in MultiplayerHandler.spawnCommands:
		var hudItem = HUD_SPAWN_ITEM.instantiate()
		hud_spawn_container.add_child(hudItem)
		hudItem.setup(spawnCommand)
