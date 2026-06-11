extends Node

var finished_obstacles : int = 0

func add_obstacles() -> void:
	finished_obstacles += 1

func get_obstacle() -> int:
	return finished_obstacles

func clear_obstacle_counter() -> void:
	finished_obstacles = 0
