extends Node

@onready var main_menu: Control = %MainMenu
@onready var settings_menu: Control = %SettingsMenu
@onready var credits_menu: Control = %CreditsMenu
@onready var animation_player: AnimationPlayer = %AnimationPlayer
const HUE_SHIFT_MAT = preload("res://shaders/hue_shift_mat.tres")


func _ready():
	#main_menu.click_start.connect()
	main_menu.click_settings.connect(on_click_settings)
	main_menu.click_credits.connect(on_click_credits)
	settings_menu.click_exit.connect(on_click_exit_settings)
	credits_menu.click_exit.connect(on_click_exit_credits)
	main_menu.onStart()
	
func on_click_settings():
	get_viewport().gui_disable_input = true
	animation_player.play("green")
	await animation_player.animation_finished
	get_viewport().gui_disable_input = false
	settings_menu.onStart()

func on_click_exit_settings():
	get_viewport().gui_disable_input = true
	animation_player.play_backwards("green")
	await animation_player.animation_finished
	get_viewport().gui_disable_input = false
	main_menu.onStart()

func on_click_credits():
	get_viewport().gui_disable_input = true
	animation_player.play("orange")
	await animation_player.animation_finished
	get_viewport().gui_disable_input = false
	credits_menu.onStart()

func on_click_exit_credits():
	get_viewport().gui_disable_input = true
	animation_player.play_backwards("orange")
	await animation_player.animation_finished
	get_viewport().gui_disable_input = false
	main_menu.onStart()
