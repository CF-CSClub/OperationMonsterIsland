class_name TurnManager
extends Node
## Manages turn phases and player order within a match.
## Implements the Planning -> Reveal -> Action -> Round End cycle.

signal phase_changed(old_phase: GameConfig.TurnPhase, new_phase: GameConfig.TurnPhase)
signal player_turn_started(player_id: int)
signal player_turn_ended(player_id: int)

var _current_phase: GameConfig.TurnPhase = GameConfig.TurnPhase.SETUP
var _current_round: int = 0
var _current_player_index: int = 0
var _player_order: Array[int] = []
var _player_count: int = 2

# Track which players are ready during planning
var _ready_players: Array[int] = []


func _ready() -> void:
	GameSignals.match_started.connect(_on_match_started)
	GameSignals.player_ready.connect(_on_player_ready)

	# If we're already in game state, start the match
	# (handles case where signal fired before we existed)
	if GameConfig.current_state == GameConfig.GameState.IN_GAME:
		call_deferred("_on_match_started")


func _on_match_started() -> void:
	_player_count = GameConfig.current_player_count
	_setup_match()


func _setup_match() -> void:
	_current_round = 0
	_current_player_index = 0
	_ready_players.clear()
	
	# Initialize player order (will be sorted by speed later)
	_player_order.clear()
	for i in range(_player_count):
		_player_order.append(i)
	
	_set_phase(GameConfig.TurnPhase.SETUP)
	
	if GameConfig.debug_mode:
		print("[TurnManager] Match setup with %d players" % _player_count)
	
	# Start first round
	_start_round()


func _start_round() -> void:
	_current_round += 1
	_current_player_index = 0
	_ready_players.clear()
	
	GameSignals.round_started.emit(_current_round)
	
	if GameConfig.debug_mode:
		print("[TurnManager] Round %d started" % _current_round)
	
	# Start planning phase
	_set_phase(GameConfig.TurnPhase.PLANNING)
	_start_planning_for_player(0)


func _start_planning_for_player(player_id: int) -> void:
	GameSignals.planning_started.emit(player_id)
	
	if GameConfig.debug_mode:
		print("[TurnManager] Planning started for Player %d" % (player_id + 1))


func _on_player_ready(player_id: int) -> void:
	if player_id not in _ready_players:
		_ready_players.append(player_id)
		GameSignals.planning_ended.emit(player_id)
		
		if GameConfig.debug_mode:
			print("[TurnManager] Player %d is ready" % (player_id + 1))
	
	# Check if all players are ready
	if _ready_players.size() >= _player_count:
		_all_players_ready()
	else:
		# Start planning for next player (hotseat)
		var next_player = _ready_players.size()
		if next_player < _player_count:
			_start_planning_for_player(next_player)


func _all_players_ready() -> void:
	# Transition to reveal speed phase
	_set_phase(GameConfig.TurnPhase.REVEAL_SPEED)
	
	if GameConfig.debug_mode:
		print("[TurnManager] All players ready - revealing speed values")
	
	# TODO: Sort player order by speed values
	# For now, just proceed to action phase
	_start_action_phase()


func _start_action_phase() -> void:
	_set_phase(GameConfig.TurnPhase.ACTION)
	_current_player_index = 0
	_start_player_turn()


func _start_player_turn() -> void:
	if _player_order.is_empty() or _current_player_index >= _player_order.size():
		push_error("[TurnManager] Cannot start turn - invalid player order state")
		return

	var current_player = _player_order[_current_player_index]
	GameSignals.action_phase_started.emit(current_player)
	player_turn_started.emit(current_player)

	if GameConfig.debug_mode:
		print("[TurnManager] Player %d's turn" % (current_player + 1))


func end_current_turn() -> void:
	if _player_order.is_empty() or _current_player_index >= _player_order.size():
		push_error("[TurnManager] Cannot end turn - invalid player order state")
		return

	var current_player = _player_order[_current_player_index]
	GameSignals.action_phase_ended.emit(current_player)
	player_turn_ended.emit(current_player)
	
	_current_player_index += 1
	
	if _current_player_index >= _player_count:
		_end_round()
	else:
		_start_player_turn()


func _end_round() -> void:
	_set_phase(GameConfig.TurnPhase.ROUND_END)
	GameSignals.round_ended.emit(_current_round)
	
	if GameConfig.debug_mode:
		print("[TurnManager] Round %d ended" % _current_round)
	
	# Start next round
	_start_round()


func _set_phase(new_phase: GameConfig.TurnPhase) -> void:
	var old_phase = _current_phase
	_current_phase = new_phase
	phase_changed.emit(old_phase, new_phase)
	GameSignals.turn_phase_changed.emit(new_phase)


func get_current_phase() -> GameConfig.TurnPhase:
	return _current_phase


func get_current_round() -> int:
	return _current_round


func get_current_player() -> int:
	if _current_player_index < _player_order.size():
		return _player_order[_current_player_index]
	return -1


func get_phase_name() -> String:
	return GameConfig.TurnPhase.keys()[_current_phase]
