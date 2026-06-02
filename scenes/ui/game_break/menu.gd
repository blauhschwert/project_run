class_name GameBreakMenuLayer
extends Control

@onready var game_break_buttons: GameBreakButtons = $VBoxContainer/GameBreakButtons
@onready var options: Options = $VBoxContainer/Options

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_game_break_buttons_open_options() -> void:
	game_break_buttons.hide()
	options.show()


func _on_options_close_options() -> void:
	options.hide()
	game_break_buttons.show()
