extends ColorRect
@onready var entity_name: Label = %EntityName
@onready var price: Label = %Price
@onready var texture_rect: TextureRect = %TextureRect


func setup(spawnCommand: SpawnCommand):
	var rect = TextureRect.new()
	texture_rect.texture = spawnCommand.viewport.get_texture()
	entity_name.text = spawnCommand.name
	price.text = str(spawnCommand.cost)
