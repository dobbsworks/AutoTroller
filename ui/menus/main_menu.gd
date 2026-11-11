extends Control

signal click_start()
signal click_settings()
signal click_credits()
signal click_instructions()
signal click_version_history()
@onready var button_start: Button = %ButtonStart
@onready var connection_panel: Panel = %ConnectionPanel


func _on_button_start_pressed() -> void:
	click_start.emit()

func _on_button_settings_pressed() -> void:
	click_settings.emit()

func _on_button_credits_pressed() -> void:
	click_credits.emit()

func _on_button_exit_pressed() -> void:
	get_tree().quit() 
	
func onStart():
	button_start.grab_focus()


func _on_button_instructions_pressed() -> void:
	click_instructions.emit()


func _on_version_pressed() -> void:
	click_version_history.emit()
