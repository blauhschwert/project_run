extends Node2D



const STONE_SCENE : PackedScene = preload("res://scenes/stone/stone.tscn")

@onready var entity_spawn: Marker2D = $EntitySpawn

@onready var lane_positions: Node2D = $LanePositions

@onready var player: Player = $Player



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	player.position = lane_positions.get_child(0).position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _create_stone_instance() -> void:
	var stone = STONE_SCENE.instantiate()
	stone.position = entity_spawn.position
	stone.set_direction_vector(entity_spawn.position, $EntityEnds.get_child(randi() % 3).position)
	add_child(stone)

func _on_player_change_lane(lane: int) -> void:
	player.position = lane_positions.get_child(lane).position


func _on_entity_timer_timeout() -> void:
	_create_stone_instance()
