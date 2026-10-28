extends Node

@export_enum("vertical", "horizontal") var scrollType = 0
@export var scrollSpeed = 50.0
@export var startPause = 2.0
@export var endPause = 2.0

var scrollable: ScrollContainer
var propertyName = ""
var internalScroll = 0.0

func _ready() -> void:
	var parent = get_parent()
	if parent is ScrollContainer:
		scrollable = parent
	propertyName = "scroll_vertical" if scrollType == 0 else "scroll_horizontal"
		
	
var activeScroll = true
var oldScroll = 0.0
var targetScroll = 0.0
var matchTimer = 0.0
func _process(delta: float) -> void:
	if !scrollable: return
	var currentScroll = scrollable.get(propertyName)
	
	if activeScroll:
		targetScroll = internalScroll + scrollSpeed * delta
		internalScroll = targetScroll
		scrollable.set(propertyName, targetScroll)
	elif targetScroll == 0.0:
		var lerpScrollValue = lerpf(internalScroll, targetScroll, 0.1 )
		internalScroll = lerpScrollValue
		scrollable.set(propertyName, internalScroll)
	
	currentScroll = scrollable.get(propertyName)
	if oldScroll != currentScroll:
		oldScroll = currentScroll
		matchTimer = 0.0
	else:
		matchTimer += delta
		if matchTimer >= endPause:
			pauseScroll()
	
func pauseScroll():
	activeScroll = false
	targetScroll = 0.0
	await get_tree().create_timer(startPause).timeout
	activeScroll = true
	
	
