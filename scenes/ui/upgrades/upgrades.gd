class_name Upgrades
extends Control

signal finished_upgrade(amount)

var food_icons  := [6,7,12,13,27,28]

var score_upgrade : float = 1.0
var live_upgrade : int = 0

@onready var food_icon: FoodIcon = $FoodIcon

func _init(p_score := 1.0, p_live := 0) -> void:
	score_upgrade = p_score
	live_upgrade = p_live

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if score_upgrade >= 6:
		$NinePatchRect/UpgradeText.text = "Score Upgrade lvl : " + str(int(score_upgrade))
		food_icon.frame = food_icons[0]
	else:
		$NinePatchRect/UpgradeText.text = "Score Upgrade \n lvl : " + str(int(score_upgrade))
		food_icon.frame = food_icons[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_nine_patch_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("press"):
		finished_upgrade.emit(score_upgrade)
		print("hello")
