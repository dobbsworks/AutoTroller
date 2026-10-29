extends Node2D

var player: CharacterBody2D

@export var bounceDownRatio = 0.0
@export var bounceDownRequiresClearance = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer


signal onPlayerHitFromBelow(player: CharacterBody2D)


func _process(delta: float) -> void:
	if !player: 
		player = GameState.shared.player
		return
		
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !player: return
	if player.velocity.y < 0.0: 
		if player.global_position.y > self.global_position.y + 8.0: 
			var canBounceDown = bounceDownRatio != 0
			#if bounceDownRequiresHorizClose:
				#if abs(player.global_position.x - self.global_position.x) > 8:
					#canBounceDown = false
			if canBounceDown: 
				player.velocity.y = 360 * bounceDownRatio
				animation_player.play("RESET")
				animation_player.queue("pop-up")
			onPlayerHitFromBelow.emit(player)
	
