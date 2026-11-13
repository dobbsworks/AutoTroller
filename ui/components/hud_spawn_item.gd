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
	
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.4
	timer.start()
	timer.timeout.connect(refresh)
		
func _process(delta: float) -> void:
	visible = command.isActive

func refresh():
	var cost = command.getCurrentCost()
	var isDiscounted = cost < command.cost
	%SALE.visible = isDiscounted
	price.text = str(cost)
	if cost < 0:
		price.text = "+" + str(abs(cost))
	
	
