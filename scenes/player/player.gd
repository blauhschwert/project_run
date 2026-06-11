class_name Player
extends CharacterBody2D

signal change_lane(lane:int)
signal player_hit
signal entered_portal

enum PlayerStates {NONE,PLAY, BREAK, GAME_OVER}

var play_state = PlayerStates.NONE
var direction : Vector2 = Vector2.ZERO

var lanes : Array = [-1, 0, 1]
var lane_idx : int = 0 

# mouse or swipe movement
var length = 100
var startPos : Vector2
var curPos : Vector2
var swipping = false

var threshold = 10

func _ready() -> void:
	$Portal.hide()

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
		
	if Input.is_action_just_pressed("press"):
		if !swipping:
			swipping = true
			startPos = get_global_mouse_position()
			#print("StartPos" , startPos)
	
	if Input.is_action_pressed("press"):
		if swipping:
			curPos = get_global_mouse_position()
			if startPos.distance_to(curPos) >= length:
				if abs(startPos.y - curPos.y) <= threshold:
					#print("Horizontal Swipe")
					if (curPos.x - startPos.x) <= 0:
						lane_idx -= 1
						change_lane.emit(lane_idx)
					else:
						lane_idx += 1
						change_lane.emit(lane_idx)
					swipping = false
				# Vertical Swipe	
				#if abs(startPos.x - curPos.x) <= threshold:
					#print("Vertical Swipe")
					#swipping = false
	else:
		swipping = false


func _physics_process(_delta: float) -> void:
	match play_state:
		PlayerStates.NONE:
			$AnimationPlayer.pause()
			set_process_input(false)
		PlayerStates.PLAY:
			set_process_input(true)
			$AnimationPlayer.play("walk")
		PlayerStates.BREAK:
			_player_break()
		PlayerStates.GAME_OVER:
			_game_over()

func chnage_play_state(p_state : PlayerStates) -> void:
	play_state = p_state

func change_worlds() -> void:
	$AnimationPlayer.play("change_worlds")
	entered_portal.emit()

func _player_break() -> void:
	set_process_input(false)
	$AnimationPlayer.pause()

func _game_over() -> void:
	set_process_input(false)
	$AnimationPlayer.pause()
	player_hit.emit()
