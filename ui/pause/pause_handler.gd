extends Node2D
@onready var settings_menu: Control = $CanvasLayer/PauseScreen/SettingsMenu
@onready var pause_screen: Control = $CanvasLayer/PauseScreen

func _ready():
	settings_menu.click_exit.connect(unpause)
	pause_screen.visible = get_tree().paused

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			unpause()
		else:
			pause()

func pause():
	get_tree().paused = true
	AudioServer.set_bus_effect_enabled(2, 0, true)
	pause_screen.visible = get_tree().paused
	

func unpause():
	get_tree().paused = false
	AudioServer.set_bus_effect_enabled(2, 0, false)
	pause_screen.visible = get_tree().paused
