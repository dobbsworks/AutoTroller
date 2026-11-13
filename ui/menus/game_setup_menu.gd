extends Control

@onready var button_exit: Button = $VBoxContainer/HBoxContainer/ButtonExit

signal click_exit()
@onready var button_start_game: Button = %ButtonStartGame
@onready var status_label: Label = %StatusLabel
@onready var status_label_deeper: Label = %StatusLabelDeeper
@onready var submenu_animation: AnimationPlayer = $SubmenuAnimation

@onready var line_edit: LineEdit = %LineEdit
@onready var bot_count: SpinBox = %botCount
@onready var life_count: SpinBox = %lifeCount
@onready var queue_hidden: CheckBox = %queueHidden
@onready var button_exit_connections: Button = %ButtonExitConnections
@onready var file_status: Label = %FileStatus
@onready var file_dialog: FileDialog = $FileDialog
@onready var file_based_checkbox: CheckBox = %FileBasedCheckbox

@onready var connect_button: Button = %ConnectButton
@onready var disconnect_button: Button = %DisconnectButton
@onready var chat_file_label: Label = %ChatFileLabel
@onready var file_status_summary: Label = %FileStatusSummary

var isDisconnecting = false

var lockedIn = false
const TRANSITION_SCREEN = preload("res://ui/transitionScreen.tscn")

func _on_button_start_game_pressed() -> void:
	if !lockedIn:
		lockedIn = true
		var transScene = TRANSITION_SCREEN.instantiate()
		get_tree().current_scene.add_sibling(transScene)
		var path = "res://game.tscn"
		LevelManager.shufflePath()
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
	file_based_checkbox.button_pressed = SaveManager.saveData.useFileChat
	%autoconnect.button_pressed = SaveManager.saveData.autoconnect
	
	life_count.value = SaveManager.saveData.lives
	bot_count.value = SaveManager.saveData.botCount
	queue_hidden.button_pressed = SaveManager.saveData.queueHidden
	if SaveManager.saveData.username != "":
		line_edit.text = SaveManager.saveData.username


func _process(delta: float) -> void:
	status_label.text = ""
	var labelColor = Color.WHITE
	
	var integrationService = MultiplayerHandler.integration_service
	var isConnected = integrationService.isConnected
	var isConnecting = integrationService.isConnecting || isDisconnecting
	
	
	connect_button.disabled = line_edit.text.length() < 4 # min username length
	
	if line_edit.text == integrationService.connectedName && isConnected:
		connect_button.disabled = true
	
	if isConnecting:
		status_label.text = "Connecting..."
		labelColor = Color.YELLOW
		button_start_game.disabled = true
		line_edit.editable = false
		connect_button.disabled = true
		disconnect_button.disabled = true
	else:
		line_edit.editable = true
		if isConnected:
			status_label.text = "Connected as " + integrationService.connectedName
			labelColor = Color.GREEN
			button_start_game.disabled = false
			button_start_game.text = "PLAY"
			disconnect_button.disabled = false
		else:
			disconnect_button.disabled = true
			status_label.text = "Not connected"
			labelColor = Color.ORANGE
			if FileHandler.isActive():
				button_start_game.disabled = false
				button_start_game.text = "PLAY (NO DIRECT TWITCH CONNECTION)"
			elif bot_count.value > 0:
				button_start_game.disabled = false
				button_start_game.text = "PLAY OFFLINE (CPUs ONLY)"
			else:
				button_start_game.disabled = true
			
	if bot_count.get_line_edit().has_focus():
		if Input.is_action_just_pressed("run"):
			bot_count.value -= 1
		if Input.is_action_just_pressed("jump"):
			bot_count.value += 1
	if life_count.get_line_edit().has_focus():
		if Input.is_action_just_pressed("run"):
			life_count.value -= 1
		if Input.is_action_just_pressed("jump"):
			life_count.value += 1
	
	status_label_deeper.text = status_label.text
	status_label.add_theme_color_override("font_color", labelColor) 
	status_label_deeper.add_theme_color_override("font_color", labelColor) 
	
	
	file_status_summary.text = ""
	chat_file_label.text = "No file selected"
	if SaveManager.saveData.filePath:
		chat_file_label.text = SaveManager.saveData.filePath.split("/")[-1]
		if SaveManager.saveData.useFileChat:
			file_status_summary.text = "Chat file active"
	
	

func _on_connect_button_pressed() -> void:
	MultiplayerHandler.integration_service.SetupTwitchConnection(line_edit.text)


func _on_line_edit_text_submitted(new_text: String) -> void:
	MultiplayerHandler.integration_service.SetupTwitchConnection(line_edit.text)


func _on_spin_box_value_changed(value: float) -> void:
	SaveManager.saveData.botCount = int(value)
	SaveManager.saveGame()


func _on_life_count_value_changed(value: float) -> void:
	GameState.defaultRound.lives = value
	GameState.round.lives = value
	SaveManager.saveData.lives = value
	SaveManager.saveGame()



func _on_queue_hidden_toggled(toggled_on: bool) -> void:
	SaveManager.saveData.queueHidden = toggled_on
	SaveManager.saveGame()
	


func _on_button_connections_pressed() -> void:
	get_viewport().gui_disable_input = true
	submenu_animation.play("flipToConnection")
	await submenu_animation.animation_finished
	get_viewport().gui_disable_input = false
	button_exit_connections.grab_focus()


func _on_button_exit_connections_pressed() -> void:
	get_viewport().gui_disable_input = true
	submenu_animation.play_backwards("flipToConnection")
	await submenu_animation.animation_finished
	get_viewport().gui_disable_input = false
	button_start_game.grab_focus()


func _on_select_file_button_pressed() -> void:
	file_dialog.popup_centered_clamped()
	


func _on_disconnect_button_pressed() -> void:
	isDisconnecting = true
	await MultiplayerHandler.integration_service.Unsetup()
	isDisconnecting = false
	SaveManager.saveData.username = ""
	SaveManager.saveGame()


func _on_file_based_checkbox_toggled(toggled_on: bool) -> void:
	SaveManager.saveData.useFileChat = toggled_on
	SaveManager.saveGame()


func _on_file_dialog_file_selected(path: String) -> void:
	SaveManager.saveData.filePath = path
	SaveManager.saveGame()


func _on_autoconnect_toggled(toggled_on: bool) -> void:
	SaveManager.saveData.autoconnect = toggled_on
	SaveManager.saveGame()
