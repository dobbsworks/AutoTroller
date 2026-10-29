extends Control

@onready var button_exit: Button = $VBoxContainer/HBoxContainer/ButtonExit

signal click_exit()
@onready var button_start_game: Button = %ButtonStartGame
@onready var status_label: Label = %StatusLabel
@onready var line_edit: LineEdit = %LineEdit
@onready var connect_button: Button = %ConnectButton
@onready var connection_details: Label = %ConnectionDetails
@onready var bot_count: SpinBox = $VBoxContainer/Panel2/MarginContainer/VBoxContainer/HBoxContainer/botCount
var lockedIn = false
const TRANSITION_SCREEN = preload("res://ui/transitionScreen.tscn")

func _on_button_start_game_pressed() -> void:
	if !lockedIn:
		lockedIn = true
		var transScene = TRANSITION_SCREEN.instantiate()
		get_tree().current_scene.add_sibling(transScene)
		var path = "res://game.tscn"
		await get_tree().create_timer(1.0).timeout
		MultiplayerHandler.isActive = true
		MultiplayerHandler.Reset()
		transScene.get_node("CanvasLayer/AnimationPlayer").play("fade")
		get_tree().change_scene_to_file(path)


func _on_button_exit_pressed() -> void:
	click_exit.emit()

func onStart():
	button_exit.grab_focus()


func refresh():
	bot_count.value = SaveManager.saveData.botCount
	if SaveManager.saveData.username != "":
		line_edit.text = SaveManager.saveData.username


func _process(delta: float) -> void:
	status_label.text = ""
	
	var integrationService = MultiplayerHandler.integration_service
	var isConnected = integrationService.isConnected
	var isConnecting = integrationService.isConnecting
	
	
	connect_button.disabled = line_edit.text.length() < 4 # min username length
	
	if line_edit.text == integrationService.connectedName && isConnected:
		connect_button.disabled = true
	
	if isConnecting:
		status_label.text = "Connecting..."
		status_label.add_theme_color_override("font_color", Color.YELLOW) 
		button_start_game.disabled = true
		line_edit.editable = false
		connect_button.disabled = true
	else:
		line_edit.editable = true
		if isConnected:
			status_label.text = "Connected as " + integrationService.connectedName
			status_label.add_theme_color_override("font_color", Color.GREEN) 
			button_start_game.disabled = false
		else:
			status_label.text = "Not connected"
			status_label.add_theme_color_override("font_color", Color.ORANGE) 
			button_start_game.disabled = true
			
			
	


func _on_connect_button_pressed() -> void:
	MultiplayerHandler.integration_service.SetupTwitchConnection(line_edit.text)


func _on_line_edit_text_submitted(new_text: String) -> void:
	MultiplayerHandler.integration_service.SetupTwitchConnection(line_edit.text)


func _on_spin_box_value_changed(value: float) -> void:
	SaveManager.saveData.botCount = int(value)
	SaveManager.saveGame()
