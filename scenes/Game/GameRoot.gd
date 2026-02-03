extends Node
## Root node for the game scene.
## Contains BoardView, UIRoot, and TurnManager as children.

@onready var board_view: Node2D = $BoardView
@onready var ui_root: Control = $UIRoot
@onready var turn_manager: TurnManager = $TurnManager


func _ready() -> void:
	if GameConfig.debug_mode:
		print("[GameRoot] Game scene loaded with %d players" % GameConfig.current_player_count)


func _unhandled_input(event: InputEvent) -> void:
	# ESC to return to menu (for testing)
	if event.is_action_pressed("ui_cancel"):
		_return_to_menu()


func _return_to_menu() -> void:
	var app_root = get_node("/root/AppRoot")
	if app_root and app_root.has_method("return_to_menu"):
		app_root.return_to_menu()
