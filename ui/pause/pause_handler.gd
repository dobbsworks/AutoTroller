extends Node2D
@onready var settings_menu: Control = $CanvasLayer/PauseScreen/SettingsMenu
@onready var pause_screen: Control = $CanvasLayer/PauseScreen

func _ready():
	settings_menu.click_exit.connect(unpause)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = false
		else:
			get_tree().paused = true
	pause_screen.visible = get_tree().paused

func unpause():
	get_tree().paused = false
	pause_screen.visible = get_tree().paused
