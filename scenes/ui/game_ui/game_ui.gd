class_name GameUI
extends Control

var game_score : int = 0

@onready var game_score_label : Label = $background/GameScore

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_update_game_score()

func _update_game_score() -> void:
	game_score_label.text = str(game_score).pad_zeros(7)


func _on_world_change_game_score(amount: Variant) -> void:
	game_score = amount
