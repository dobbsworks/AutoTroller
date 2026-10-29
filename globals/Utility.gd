extends Node


func copyObj(from, to):
	# quick and dirty, used for game state
	for k in from:
		to[k] = from[k]
