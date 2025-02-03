extends Node2D

@onready var hokuToken : Sprite2D = $HokuToken
@onready var spotTwo: Marker2D = $SpotTwo


func _unhandled_input(event: InputEvent) -> void:
	var tween = create_tween()
	
	if Input.is_action_just_pressed("ui_left"):
		tween.tween_property(hokuToken, "position", Vector2(hokuToken.position.x - 10, hokuToken.position.y), 0.1)
		
	if Input.is_action_just_pressed("ui_right"):
		tween.tween_property(hokuToken, "position", Vector2(hokuToken.position.x + 10, hokuToken.position.y), 0.1)
	
	if Input.is_action_just_pressed("ui_up"):
		tween.tween_property(hokuToken, "position", Vector2(hokuToken.position.x, hokuToken.position.y - 10), 0.1)
	
	if Input.is_action_just_pressed("ui_down"):
		tween.tween_property(hokuToken, "position", Vector2(hokuToken.position.x, hokuToken.position.y + 10), 0.1)
