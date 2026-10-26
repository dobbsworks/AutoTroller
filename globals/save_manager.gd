extends Node



var saveData = {
	"volumeSfx": 0.8,
	"volumeMusic": 0.8,
}

var defaultState = {}

func _ready() -> void:
	for key in saveData.keys():
		defaultState[key] = saveData[key]
	loadGame()

func clearSave():
	for key in defaultState.keys():
		saveData[key] = defaultState[key]
	saveGame()
	
	
	
func saveGame():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(saveData)
	save_file.store_line(json_string)
	
func loadGame():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		# Creates the helper class to interact with JSON.
		var json = JSON.new()
		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		# Get the data from the JSON object.
		var node_data = json.data
		for key in node_data.keys():
			saveData[key] = node_data[key]
	
	
