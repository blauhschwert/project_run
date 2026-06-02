extends Node

var finished_stones : int = 0

func add_stone() -> void:
	finished_stones += 1

func get_stones() -> int:
	return finished_stones

func clear_stone_counter() -> void:
	finished_stones = 0
