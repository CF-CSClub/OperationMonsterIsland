class_name GameStateMachine
extends Node
## Finite State Machine for managing high-level game states.
## Controls transitions between menu, gameplay, pause, and game over states.

signal state_entered(state: GameConfig.GameState)
signal state_exited(state: GameConfig.GameState)

var _current_state: GameConfig.GameState = GameConfig.GameState.NONE
var _previous_state: GameConfig.GameState = GameConfig.GameState.NONE

# Dictionary of valid state transitions
var _valid_transitions: Dictionary = {
	GameConfig.GameState.NONE: [GameConfig.GameState.MAIN_MENU],
	GameConfig.GameState.MAIN_MENU: [GameConfig.GameState.IN_GAME],
	GameConfig.GameState.IN_GAME: [GameConfig.GameState.PAUSED, GameConfig.GameState.GAME_OVER, GameConfig.GameState.MAIN_MENU],
	GameConfig.GameState.PAUSED: [GameConfig.GameState.IN_GAME, GameConfig.GameState.MAIN_MENU],
	GameConfig.GameState.GAME_OVER: [GameConfig.GameState.MAIN_MENU, GameConfig.GameState.IN_GAME]
}


func _ready() -> void:
	# Start in MAIN_MENU state
	transition_to(GameConfig.GameState.MAIN_MENU)


func get_current_state() -> GameConfig.GameState:
	return _current_state


func get_previous_state() -> GameConfig.GameState:
	return _previous_state


func can_transition_to(new_state: GameConfig.GameState) -> bool:
	if _current_state not in _valid_transitions:
		return false
	return new_state in _valid_transitions[_current_state]


func transition_to(new_state: GameConfig.GameState) -> bool:
	# Validate transition
	if _current_state != GameConfig.GameState.NONE and not can_transition_to(new_state):
		push_warning("[GameStateMachine] Invalid transition from %s to %s" % [
			GameConfig.GameState.keys()[_current_state],
			GameConfig.GameState.keys()[new_state]
		])
		return false
	
	# Exit current state
	if _current_state != GameConfig.GameState.NONE:
		_exit_state(_current_state)
		state_exited.emit(_current_state)
	
	# Transition
	_previous_state = _current_state
	_current_state = new_state
	
	# Enter new state
	_enter_state(new_state)
	state_entered.emit(new_state)
	
	# Update global config
	GameConfig.set_game_state(new_state)
	
	if GameConfig.debug_mode:
		print("[GameStateMachine] Transitioned to: %s" % GameConfig.GameState.keys()[new_state])
	
	return true


func _enter_state(state: GameConfig.GameState) -> void:
	match state:
		GameConfig.GameState.MAIN_MENU:
			_on_enter_main_menu()
		GameConfig.GameState.IN_GAME:
			_on_enter_in_game()
		GameConfig.GameState.PAUSED:
			_on_enter_paused()
		GameConfig.GameState.GAME_OVER:
			_on_enter_game_over()


func _exit_state(state: GameConfig.GameState) -> void:
	match state:
		GameConfig.GameState.MAIN_MENU:
			_on_exit_main_menu()
		GameConfig.GameState.IN_GAME:
			_on_exit_in_game()
		GameConfig.GameState.PAUSED:
			_on_exit_paused()
		GameConfig.GameState.GAME_OVER:
			_on_exit_game_over()


# =============================================================================
# STATE ENTER/EXIT HANDLERS
# =============================================================================
func _on_enter_main_menu() -> void:
	pass  # Scene loading handled by AppRoot


func _on_exit_main_menu() -> void:
	pass


func _on_enter_in_game() -> void:
	GameSignals.match_started.emit()


func _on_exit_in_game() -> void:
	pass


func _on_enter_paused() -> void:
	get_tree().paused = true


func _on_exit_paused() -> void:
	get_tree().paused = false


func _on_enter_game_over() -> void:
	pass


func _on_exit_game_over() -> void:
	pass
