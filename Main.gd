extends Node2D

@onready var hokuToken : Sprite2D = $HokuToken
@onready var spotTwo: Marker2D = $SpotTwo
@export var gameSpaces: Array[Node]
var place : int = 0


func _unhandled_input(event: InputEvent) -> void:
	var tween := create_tween()
	if event is InputEventKey:
		match event:
			KEY_LEFT:
				tween.tween_property(hokuToken, "position", Vector2(hokuToken.position.x - 10, hokuToken.position.y), 0.1)
			KEY_RIGHT:
				tween.tween_property(hokuToken, "position", Vector2(hokuToken.position.x + 10, hokuToken.position.y), 0.1)
			KEY_UP:
				tween.tween_property(hokuToken, "position", Vector2(hokuToken.position.x, hokuToken.position.y - 10), 0.1)
			KEY_DOWN:
				tween.tween_property(hokuToken, "position", Vector2(hokuToken.position.x, hokuToken.position.y + 10), 0.1)
