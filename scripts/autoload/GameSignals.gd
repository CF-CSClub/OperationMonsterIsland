extends Node
## Global signal bus for decoupled communication between systems.
## All game-wide signals are defined here to avoid tight coupling.

# =============================================================================
# SCENE MANAGEMENT SIGNALS
# =============================================================================
signal scene_change_requested(scene_path: String)
signal scene_loaded(scene_name: String)

# =============================================================================
# GAME STATE SIGNALS
# =============================================================================
signal game_state_changed(old_state: int, new_state: int)
signal match_started()
signal match_ended(winner_id: int)

# =============================================================================
# TURN MANAGEMENT SIGNALS
# =============================================================================
signal turn_phase_changed(new_phase: int)
signal planning_started(player_id: int)
signal planning_ended(player_id: int)
signal action_phase_started(player_id: int)
signal action_phase_ended(player_id: int)
signal round_started(round_number: int)
signal round_ended(round_number: int)

# =============================================================================
# DICE SIGNALS
# =============================================================================
signal dice_rolled(player_id: int, dice_values: Array)
signal dice_assigned(player_id: int, slot_id: String, die_value: int)
signal dice_unassigned(player_id: int, slot_id: String)
signal player_ready(player_id: int)

# =============================================================================
# TOKEN/CHARACTER SIGNALS
# =============================================================================
signal token_selected(character_id: int)
signal token_deselected(character_id: int)
signal move_preview_updated(reachable_hexes: Array)
signal character_moved(character_id: int, from_hex: Vector2i, to_hex: Vector2i)

# =============================================================================
# COMBAT SIGNALS
# =============================================================================
signal attack_declared(attacker_id: int, target_ids: Array, attack_data: Dictionary)
signal damage_applied(target_id: int, amount: int, new_hp: int)
signal character_defeated(character_id: int)

# =============================================================================
# UI SIGNALS
# =============================================================================
signal ui_action_confirmed(action_type: String, data: Dictionary)
signal ui_action_cancelled()
signal tooltip_requested(text: String, position: Vector2)
signal tooltip_hidden()
