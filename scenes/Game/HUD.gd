extends Control
## Heads-Up Display showing game state information.
## Displays current phase, round, player turn, and action buttons.

@onready var phase_label: Label = $TopBar/PhaseLabel
@onready var round_label: Label = $TopBar/RoundLabel
@onready var player_label: Label = $TopBar/PlayerLabel
@onready var end_turn_button: Button = $BottomBar/EndTurnButton
@onready var ready_button: Button = $BottomBar/ReadyButton
@onready var back_button: Button = $TopBar/BackButton
@onready var debug_label: Label = $DebugLabel

var _current_player: int = 0


func _ready() -> void:
	# Connect to game signals
	GameSignals.turn_phase_changed.connect(_on_phase_changed)
	GameSignals.round_started.connect(_on_round_started)
	GameSignals.planning_started.connect(_on_planning_started)
	GameSignals.action_phase_started.connect(_on_action_started)

	# Connect buttons
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	ready_button.pressed.connect(_on_ready_pressed)
	back_button.pressed.connect(_on_back_pressed)

	# Initial state
	_update_display()
	_set_planning_mode(false)


func _on_phase_changed(new_phase: int) -> void:
	var phase_name = GameConfig.TurnPhase.keys()[new_phase]
	phase_label.text = "Phase: " + phase_name

	# Toggle buttons based on phase
	match new_phase:
		GameConfig.TurnPhase.PLANNING:
			_set_planning_mode(true)
		GameConfig.TurnPhase.ACTION:
			_set_planning_mode(false)
		_:
			_set_planning_mode(false)


func _on_round_started(round_num: int) -> void:
	round_label.text = "Round: " + str(round_num)


func _on_planning_started(player_id: int) -> void:
	_current_player = player_id
	player_label.text = "Player " + str(player_id + 1) + " Planning"
	_set_planning_mode(true)


func _on_action_started(player_id: int) -> void:
	_current_player = player_id
	player_label.text = "Player " + str(player_id + 1) + "'s Turn"
	_set_planning_mode(false)


func _set_planning_mode(is_planning: bool) -> void:
	ready_button.visible = is_planning
	end_turn_button.visible = not is_planning


func _on_end_turn_pressed() -> void:
	# Find TurnManager and end turn
	var turn_manager = get_node_or_null("/root/AppRoot/SceneContainer/GameRoot/TurnManager")
	if turn_manager and turn_manager.has_method("end_current_turn"):
		turn_manager.end_current_turn()


func _on_ready_pressed() -> void:
	# Signal that current player is ready
	GameSignals.player_ready.emit(_current_player)


func _on_back_pressed() -> void:
	var app_root = get_node("/root/AppRoot")
	if app_root and app_root.has_method("return_to_menu"):
		app_root.return_to_menu()


func _update_display() -> void:
	phase_label.text = "Phase: SETUP"
	round_label.text = "Round: 0"
	player_label.text = "Waiting..."

	if GameConfig.debug_mode:
		debug_label.visible = true
		debug_label.text = "DEBUG MODE - Press ESC to return to menu"
	else:
		debug_label.visible = false
