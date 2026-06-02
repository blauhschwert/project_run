class_name Stone
extends Area2D

var start_point : Vector2 = Vector2.ZERO
var end_point : Vector2 = Vector2.ZERO

var direction : Vector2 = Vector2.ZERO

var speed : float = 0.74

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self,"scale",Vector2(5.0,5.0),3.0 * speed).set_ease(Tween.EASE_IN_OUT)

func stop_stone(p_stoping) -> void:
	if !p_stoping:
		speed = 0.0
	else:
		speed = 0.74


func set_direction_vector(p_str_pt := Vector2.ZERO,p_end_pt := Vector2.ZERO) -> void:
	direction = p_end_pt - p_str_pt

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	Global.add_stone()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("game over")
		body.chnage_play_state(Player.PlayerStates.GAME_OVER)
