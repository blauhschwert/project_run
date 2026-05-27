class_name Player
extends CharacterBody2D

signal change_lane(lane:int)

enum PlayerStates {PLAY, BREAK, GAME_OVER}

var play_state = PlayerStates.PLAY
var direction : Vector2 = Vector2.ZERO

var lanes : Array = [-1, 0, 1]
var lane_idx : int = 0 

func _ready() -> void:
	$AnimationPlayer.play("walk")

func _input(_event: InputEvent) -> void:
	# INPUT
	if Input.is_action_just_pressed("move_left") and lanes[lane_idx] != -1:
		direction = Vector2.LEFT
		lane_idx -= 1
		change_lane.emit(lane_idx)
	
	if Input.is_action_just_pressed("move_right") and lanes[lane_idx] != 1:
		direction = Vector2.RIGHT
		lane_idx += 1
		change_lane.emit(lane_idx)


func _physics_process(_delta: float) -> void:
	match play_state:
		PlayerStates.PLAY:
			pass
		PlayerStates.BREAK:
			$AnimationPlayer.pause()
		PlayerStates.GAME_OVER:
			_game_over()

func chnage_play_state(p_state : PlayerStates) -> void:
	play_state = p_state

func _game_over() -> void:
	set_process_input(false)
	$AnimationPlayer.pause()
