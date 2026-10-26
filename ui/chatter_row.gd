extends Control
@onready var label: Label = $Panel/Label
@onready var points_label: Label = $Panel/PointsLabel
@onready var animation_player: AnimationPlayer = $Panel/AnimationPlayer

var chatter: Chatter

func set_chatter(chatter: Chatter):
	visible = false
	self.chatter = chatter
	chatter.on_too_poor.connect(func(): animation_player.play("error"))
	
func _process(delta: float) -> void:
	if label.text == "": label.text = chatter.username
	points_label.text = str(chatter.points)
	
	if !visible && chatter.isActive:
		visible = true
		animation_player.play("popin")
