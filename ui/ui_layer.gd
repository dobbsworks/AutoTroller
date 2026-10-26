extends CanvasLayer

@onready var chatter_vbox: VBoxContainer = $ChatOverlay/MarginContainer/ChatterVbox
const CHATTER_ROW = preload("res://ui/chatter_row.tscn")

func _ready() -> void:
	MultiplayerHandler.on_new_chatter.connect(on_new_chatter)


func _process(delta: float) -> void:
	pass


func on_new_chatter(chatter: Chatter):
	var chatterRow = CHATTER_ROW.instantiate()
	chatterRow.set_chatter(chatter)
	chatter_vbox.add_child(chatterRow)
