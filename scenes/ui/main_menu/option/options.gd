class_name Options
extends Control

signal close_options

func _on_back_pressed() -> void:
	hide()
	close_options.emit()
