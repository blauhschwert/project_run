class_name World
extends Node2D

signal change_game_score(amount)

enum GameState {NONE, PLAY, BREAK, GAME_OVER}

const STONE_SCENE : PackedScene = preload("res://scenes/stone/stone.tscn")

var game_state := GameState.NONE
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
			$EntityTimer.paused = true
		GameState.PLAY:
			$GameUI.show()
			player.chnage_play_state(Player.PlayerStates.PLAY)
			$EntityTimer.paused = false
			_increase_game_score(3)
		GameState.BREAK:
			_show_pause_menu()
		GameState.GAME_OVER:
			_show_game_over_screen()

func change_game_state(p_state := GameState.NONE) -> void:
	game_state = p_state

func get_game_state() -> World.GameState:
	return game_state

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
	$EntityTimer.start(randf_range(1.2, 4.7))


func _on_player_player_hit() -> void:
	game_state = GameState.GAME_OVER

func _show_pause_menu() -> void:
	player.chnage_play_state(Player.PlayerStates.BREAK)
	$EntityTimer.paused = true

func _show_game_over_screen() -> void:
	$GameUI.hide()
	$GameOverScreen/GameOverPanel/Score.text = "Score: " +  str(game_score)
	$GameOverScreen.show()
	
