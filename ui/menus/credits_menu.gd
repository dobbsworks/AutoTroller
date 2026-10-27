extends Control
@onready var button_exit: Button = $VBoxContainer/ButtonExit

signal click_exit()

func _on_button_exit_pressed() -> void:
	click_exit.emit()

func onStart():
	button_exit.grab_focus()
