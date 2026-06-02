class_name World
extends Node2D

signal change_game_score(amount)

enum GameState {NONE, PLAY, BREAK, GAME_OVER}

const STONE_SCENE : PackedScene = preload("res://scenes/stone/stone.tscn")
const UPGRADE_SCENE : PackedScene = preload("res://scenes/ui/upgrades/upgrades.tscn")

var game_state := GameState.NONE
var game_score : int = 0
var current_game_bonus : int = 15
var game_speed : float = 1.0

var upgrades := []

@onready var entity_spawn: Marker2D = $EntitySpawn
@onready var lane_positions: Node2D = $LanePositions
@onready var player: Player = $Player
@onready var upgrade_options: VBoxContainer = $Upgrades/UpgradeOptions


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
			_set_stones_to_stop(true)
			_increase_game_score(current_game_bonus)
		GameState.BREAK:
			_show_pause_menu()
		GameState.GAME_OVER:
			_show_game_over_screen()
	
	if Global.get_stones() == 3:
		_create_upgrade_slot()
		Global.clear_stone_counter()
		player.chnage_play_state(Player.PlayerStates.BREAK)


func change_game_state(p_state := GameState.NONE) -> void:
	game_state = p_state

func get_game_state() -> World.GameState:
	return game_state

func _create_stone_instance() -> void:
	var stone = STONE_SCENE.instantiate()
	stone.position = entity_spawn.position
	stone.set_direction_vector(entity_spawn.position, $EntityEnds.get_child(randi() % 3).position)
	$Stones.add_child(stone)

func _increase_game_score(p_amount) -> void:
	game_score += p_amount * game_speed
	change_game_score.emit(game_score)

func _on_player_change_lane(lane: int) -> void:
	player.position = lane_positions.get_child(lane).position


func _on_entity_timer_timeout() -> void:
	_create_stone_instance()
	$EntityTimer.start(randf_range(1.2, 2.9))

func _create_upgrade_slot() -> void:
	var upgrade_opt = UPGRADE_SCENE.instantiate()
	upgrade_options.add_child(upgrade_opt)
	upgrade_opt.connect("finished_upgrade",_increase_game_bonus)
	upgrades.append(upgrade_opt)
	get_tree().paused = true
	$Upgrades.show()

func _increase_game_bonus(next_bonus : int) -> void:
	print("upgrade")
	current_game_bonus += next_bonus
	get_tree().paused = false
	$Upgrades/UpgradeOptions.remove_child(upgrades[0])

func _on_player_player_hit() -> void:
	game_state = GameState.GAME_OVER

func _show_pause_menu() -> void:
	player.chnage_play_state(Player.PlayerStates.BREAK)
	$EntityTimer.paused = true
	_set_stones_to_stop(false)

func _show_game_over_screen() -> void:
	$GameUI.hide()
	$GameOverScreen/GameOverPanel/Score.text = "Score: " +  str(game_score)
	$GameOverScreen.show()

func _set_stones_to_stop(p_is_moving) -> void:
	for i in $Stones.get_children():
		i.stop_stone(p_is_moving)
