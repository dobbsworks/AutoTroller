extends Node

@onready var menu_mouse_over: AudioStreamPlayer = $MenuSfx/MenuMouseOver
@onready var menu_select: AudioStreamPlayer = $MenuSfx/MenuSelect
@onready var menu_back: AudioStreamPlayer = $MenuSfx/MenuBack





func _ready() -> void:
	#for key in state.keys():
		#defaultState[key] = state[key]
	#loadGame()
	get_tree().node_added.connect(_on_node_added)
	_connect_buttons_in_tree(get_tree().root)


func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		connect_button(node)
		
func connect_button(buttonNode: BaseButton):
		buttonNode.pressed.connect(_play_button_select_sfx)
		buttonNode.mouse_entered.connect(_play_button_focus_sfx)
	

func _connect_buttons_in_tree(root_node: Node) -> void:
	if root_node is BaseButton:
		connect_button(root_node)
	for child in root_node.get_children():
		_connect_buttons_in_tree(child)
		
func _play_button_select_sfx() -> void:
	menu_select.play()
func _play_button_focus_sfx() -> void:
	menu_mouse_over.play()
