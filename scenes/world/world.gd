class_name World
extends Node2D

signal change_game_score(amount)

enum GameState {NONE, PLAY, BREAK, GAME_OVER}

const STONE_SCENE : PackedScene = preload("res://scenes/stone/stone.tscn")


var game_state := GameState.PLAY
var game_score : int = 0
var game_speed : float = 1.0


@onready var entity_spawn: Marker2D = $EntitySpawn

@onready var lane_positions: Node2D = $LanePositions

@onready var player: Player = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	player.position = lane_positions.get_child(0).position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match game_state:
		GameState.NONE:
			pass
		GameState.PLAY:
			_increase_game_score(3)
		GameState.BREAK:
			pass
		GameState.GAME_OVER:
			pass

func change_game_state(p_state := GameState.NONE) -> void:
	game_state = p_state

func _create_stone_instance() -> void:
	var stone = STONE_SCENE.instantiate()
	stone.position = entity_spawn.position
	stone.set_direction_vector(entity_spawn.position, $EntityEnds.get_child(randi() % 3).position)
	add_child(stone)

func _increase_game_score(p_amount) -> void:
	game_score += p_amount * game_speed
	change_game_score.emit(game_score)

func _on_player_change_lane(lane: int) -> void:
	player.position = lane_positions.get_child(lane).position


func _on_entity_timer_timeout() -> void:
	_create_stone_instance()
	$EntityTimer.start(randf_range(1.8, 6.0))


func _on_player_player_hit() -> void:
	game_state = GameState.GAME_OVER
