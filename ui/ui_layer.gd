extends CanvasLayer
@onready var chatter_vbox: VBoxContainer = %ChatterVbox
@onready var chatter_scroll_box: ScrollContainer = %ChatterScrollBox
@onready var coin_count: Label = %CoinCount
@onready var life_count: Label = %LifeCount


const CHATTER_ROW = preload("res://ui/chatter_row.tscn")

func _ready() -> void:
	MultiplayerHandler.isActive = true
	for chatter in MultiplayerHandler.chatters:
		on_new_chatter(chatter)
	MultiplayerHandler.on_new_chatter.connect(on_new_chatter)


func _process(delta: float) -> void:
	coin_count.text = ("%02d" % GameState.round.coins)
	life_count.text = ("%02d" % GameState.round.lives)

func on_new_chatter(chatter: Chatter):
	var chatterRow = CHATTER_ROW.instantiate()
	chatterRow.set_chatter(chatter)
	chatter_vbox.add_child(chatterRow)
