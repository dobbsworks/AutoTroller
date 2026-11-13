extends Node

var timeBetweenReads = 0.25
var currentWaitTime = 0.0
var currentReadPosition = 0

func isActive() -> bool:
	return SaveManager.saveData.filePath.length() > 0 && SaveManager.saveData.useFileChat


func _process(delta: float) -> void:
	if !isActive(): return
	
	currentWaitTime = move_toward(currentWaitTime, 0.0, delta)
	if currentWaitTime == 0.0:
		currentWaitTime = timeBetweenReads
		var file: FileAccess = FileAccess.open(SaveManager.saveData.filePath, FileAccess.READ)
		
		if currentReadPosition > file.get_length():
			# file has been cleared?
			currentReadPosition = 0
		
		file.seek(currentReadPosition)
		
		while file.get_position() < file.get_length():
			var readLine = file.get_line().strip_edges()
			currentReadPosition = file.get_position()
			if readLine != "":
				var pieces = readLine.split(" ", 2)
				if pieces.size() == 3:
					var platform = pieces[0]
					var username = pieces[1]
					var message = pieces[2]
					MultiplayerHandler.on_chat_received(username, message, {}, platform)
		
