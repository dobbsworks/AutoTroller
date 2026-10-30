extends Node

@onready var main_menu: Control = %MainMenu
@onready var settings_menu: Control = %SettingsMenu
@onready var credits_menu: Control = %CreditsMenu
@onready var game_setup_menu: Control = %GameSetupMenu
@onready var instructions_menu: Control = %InstructionsMenu

@onready var animation_player: AnimationPlayer = %AnimationPlayer
const HUE_SHIFT_MAT = preload("res://shaders/hue_shift_mat.tres")


func _ready():
	MultiplayerHandler.isActive = false
	main_menu.click_start.connect(on_click_play)
	main_menu.click_settings.connect(on_click_settings)
	main_menu.click_credits.connect(on_click_credits)
	main_menu.click_instructions.connect(on_click_instructions)
	settings_menu.click_exit.connect(on_click_exit_settings)
	credits_menu.click_exit.connect(on_click_exit_credits)
	game_setup_menu.click_exit.connect(on_click_exit_game_setup)
	instructions_menu.click_exit.connect(on_click_exit_instructions)
	main_menu.onStart()
	
	
func on_click_settings():
	switchToSubMenu(settings_menu, "green")
func on_click_exit_settings():
	returnFromSubMenu(settings_menu, "green")

func on_click_credits():
	switchToSubMenu(credits_menu, "orange")
func on_click_exit_credits():
	returnFromSubMenu(credits_menu, "orange")

func on_click_instructions():
	switchToSubMenu(instructions_menu, "instructions")
func on_click_exit_instructions():
	returnFromSubMenu(instructions_menu, "instructions")
	
func on_click_play():
	switchToSubMenu(game_setup_menu, "purple")
func on_click_exit_game_setup():
	returnFromSubMenu(game_setup_menu, "purple")


func switchToSubMenu(submenu: Node, animationName: String):
	if "refresh" in submenu: submenu.refresh()
	get_viewport().gui_disable_input = true
	animation_player.play(animationName)
	await animation_player.animation_finished
	get_viewport().gui_disable_input = false
	if "onStart" in submenu: submenu.onStart()
	
func returnFromSubMenu(submenu: Node, animationName: String):
	get_viewport().gui_disable_input = true
	animation_player.play_backwards(animationName)
	await animation_player.animation_finished
	get_viewport().gui_disable_input = false
	main_menu.onStart()
