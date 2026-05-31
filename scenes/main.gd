class_name MainGame
extends Node

@onready var world: World = $World

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and world.get_game_state() == world.GameState.PLAY:
		$GameBreakLayer.show()
		world.change_game_state(World.GameState.BREAK)
	

func _on_main_menu_game_started() -> void:
	world.change_game_state(World.GameState.PLAY)


func _on_start_button_pressed() -> void:
	$GameBreakLayer.hide()
	world.change_game_state(World.GameState.PLAY)
