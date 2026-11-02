extends Node

@onready var spikes_hazard: Enemy = $".."
@onready var collision_shape_2d: CollisionShape2D = $"../CollisionShape2D"
@onready var sprite_2d: Sprite2D = $"../Sprite/Sprite2D"
@export var threshold = 48.0
var isOut = true
@onready var pointy: AudioStreamPlayer = $Pointy

func _ready():
	sprite_2d.visible = false
	isOut = false

func _process(delta: float) -> void:
	if spikes_hazard.isDummy: return
	
	var player = GameState.shared.player
	if player:
		var distance = abs(player.global_position.x - spikes_hazard.global_position.x)
		
		if !isOut && distance < threshold:
			isOut = true
			sprite_2d.visible = true
			pointy.play()
		if isOut && distance > threshold + 16.0:
			isOut = false
			sprite_2d.visible = false
		
