extends Node2D

@onready var hokuToken : Sprite2D = $HokuToken
@onready var spotTwo: Marker2D = $SpotTwo
@export var gameSpaces: Array[Node]
var place : int = 0


func _unhandled_input(event: InputEvent) -> void:
	var tween = create_tween()
	match event.as_text():
		"Left":
			tween.tween_property(hokuToken, "position", Vector2(hokuToken.position.x - 10, hokuToken.position.y), 0.1)
		"Right":
			tween.tween_property(hokuToken, "position", Vector2(hokuToken.position.x + 10, hokuToken.position.y), 0.1)
		"Up":
			tween.tween_property(hokuToken, "position", Vector2(hokuToken.position.x, hokuToken.position.y - 10), 0.1)
		"Down":
			tween.tween_property(hokuToken, "position", Vector2(hokuToken.position.x, hokuToken.position.y + 10), 0.1)
