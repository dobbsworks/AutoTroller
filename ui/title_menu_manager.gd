extends Node

@onready var main_menu: Control = %MainMenu
@onready var settings_menu: Control = %SettingsMenu
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready():
	#main_menu.click_start.connect()
	main_menu.click_settings.connect(on_click_settings)
	#main_menu.click_credits.connect()
	settings_menu.click_exit.connect(on_click_exit_settings)
	
func on_click_settings():
	get_viewport().gui_disable_input = true
	animation_player.play("green")
	await animation_player.animation_finished
	get_viewport().gui_disable_input = false

func on_click_exit_settings():
	get_viewport().gui_disable_input = true
	animation_player.play_backwards("green")
	await animation_player.animation_finished
	get_viewport().gui_disable_input = false
