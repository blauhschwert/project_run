class_name GameBreakButtons
extends Control

signal play_game
signal open_options

func _ready() -> void:
	pass

func _on_start_button_pressed() -> void:
	hide()
	play_game.emit()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	open_options.emit()
