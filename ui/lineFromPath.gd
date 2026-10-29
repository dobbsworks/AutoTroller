@tool
extends Line2D

@export var path: Path2D

func _process(delta: float) -> void:
	pass
	#updateLineFromPath()
	
func updateLineFromPath():
	if !path: return
	
	var curve: Curve2D = path.curve
	clear_points()
	for point in path.curve.get_baked_points():  
		add_point(point + path.position) 
