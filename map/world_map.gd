extends Node2D
@onready var backdrop_holder: Node2D = $BackdropHolder
@onready var ground: ColorRect = $CanvasLayer/Map/Ground

func _ready() -> void:
	var levelDef: LevelDefinition = LevelManager.getLatest()
	var backdropScene = levelDef.backdrop
	var backdrop = backdropScene.instantiate()
	backdrop_holder.add_child(backdrop)
	ground.color = levelDef.groundColor
