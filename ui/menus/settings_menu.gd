extends Control


signal click_exit()
@onready var volume_music_slider: HSlider = %VolumeMusicSlider
@onready var volume_sfx_slider: HSlider = %VolumeSfxSlider
@onready var disconnect_button: Button = %DisconnectButton
@onready var cancel_disconnect: Button = %CancelDisconnect
@onready var confirm_disconnect: Button = %ConfirmDisconnect2
@onready var button_exit: Button = $VBoxContainer/ButtonExit
@onready var disconnect_confirmation: VBoxContainer = %DisconnectConfirmation
var canPlayTestSFX = false
@onready var connection_options: HBoxContainer = $VBoxContainer/ConnectionOptions
@onready var button_quit: Button = $VBoxContainer/ButtonQuit
@onready var quit_confirm: Panel = $VBoxContainer/QuitConfirm
@onready var button_cancel_quit: Button = $VBoxContainer/QuitConfirm/HBoxContainer/Panel3/ButtonCancelQuit

@export var includeConnectionOptions = true
var pauseMenu

func _ready() -> void:
	connection_options.visible = includeConnectionOptions
	button_quit.visible = !includeConnectionOptions
	quit_confirm.visible = false
	
	AudioServer.set_bus_volume_db(1, linear_to_db(SaveManager.saveData.volumeSfx))
	AudioServer.set_bus_volume_db(2, linear_to_db(SaveManager.saveData.volumeMusic))
	volume_music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	volume_sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	await get_tree().create_timer(0.1).timeout
	canPlayTestSFX = true
	
func refresh():
	disconnect_confirmation.visible = false
	disconnect_button.disabled = !MultiplayerHandler.integration_service.isConnected
	
func onStart():
	button_exit.grab_focus()
	canPlayTestSFX = true


func _on_volume_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	SaveManager.saveData.volumeMusic = value
	SaveManager.saveGame()


func _on_volume_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	SaveManager.saveData.volumeSfx = value
	SaveManager.saveGame()
	if canPlayTestSFX: $Kaizo.play()

func _on_button_exit_pressed() -> void:
	click_exit.emit()
	quit_confirm.visible = false
	button_quit.visible = !includeConnectionOptions


func _on_disconnect_button_pressed() -> void:
	disconnect_button.disabled = true
	disconnect_confirmation.visible = true


func _on_cancel_disconnect_pressed() -> void:
	disconnect_button.disabled = false
	disconnect_confirmation.visible = false


func _on_confirm_disconnect_2_pressed() -> void:
	disconnect_confirmation.visible = false
	await MultiplayerHandler.integration_service.Unsetup()
	SaveManager.saveData.username = ""
	refresh()


func _on_button_cancel_quit_pressed() -> void:
	quit_confirm.visible = false
	button_quit.visible = true


func _on_button_confirm_quit_pressed() -> void:
	GameState.resetGame()
	MultiplayerHandler.isActive = false
	pauseMenu.unpause()
	get_tree().change_scene_to_file("res://main.tscn")


func _on_button_quit_pressed() -> void:
	quit_confirm.visible = true
	button_cancel_quit.grab_focus()
	button_quit.visible = false
