extends Control

signal click_exit()

func _on_button_exit_pressed() -> void:
	click_exit.emit()
