extends Control
@onready var label: Label = $Panel/Label
@onready var points_label: Label = $Panel/PointsLabel
@onready var animation_player: AnimationPlayer = $Panel/AnimationPlayer
@onready var texture_rect: TextureRect = $Panel/TextureRect
@onready var spawn_count: Label = $Panel/TextureRect/SpawnCount

var chatter: Chatter

func set_chatter(chatter: Chatter):
	visible = false
	self.chatter = chatter
	chatter.on_too_poor.connect(onTooPoor)
	chatter.on_update_queue.connect(onUpdateQueue)
	
	
	
func _process(delta: float) -> void:
	if label.text == "": label.text = chatter.username
	points_label.text = str(chatter.points)
	
	if !visible && chatter.isActive:
		visible = true
		animation_player.play("RESET")
		animation_player.queue("popin")
		
	spawn_count.text = ""
	if chatter.spawnQueue.size() > 1: spawn_count.text = str(chatter.spawnQueue.size())
	
	if chatter.isCpu:
		get_node("Panel").self_modulate = Color.YELLOW_GREEN

func onTooPoor():
	animation_player.play("RESET")
	animation_player.queue("error")
func onUpdateQueue(spawnCommand: SpawnCommand):
	if spawnCommand == null:
		texture_rect.texture = null
	else:
		texture_rect.texture = spawnCommand.viewport.get_texture()
	
	animation_player.play("RESET")
	animation_player.queue("wiggleImage")
