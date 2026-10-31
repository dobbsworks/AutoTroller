extends ColorRect
@onready var entity_name: Label = %EntityName
@onready var price: Label = %Price
@onready var texture_rect: TextureRect = %TextureRect
var command: SpawnCommand

func setup(spawnCommand: SpawnCommand):
	command = spawnCommand
	var rect = TextureRect.new()
	if spawnCommand.viewport:
		texture_rect.texture = spawnCommand.viewport.get_texture()
	entity_name.text = spawnCommand.name
	price.text = str(spawnCommand.cost)
	if spawnCommand.cost < 0:
		price.text = "+" + str(abs(spawnCommand.cost))
		
func _process(delta: float) -> void:
	visible = command.isActive
