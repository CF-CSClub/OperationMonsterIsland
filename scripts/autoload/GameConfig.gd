extends Node
## Global game configuration and constants.
## Contains game settings, enums, and constants used across the project.

# =============================================================================
# GAME STATES
# =============================================================================
enum GameState {
	NONE,
	MAIN_MENU,
	IN_GAME,
	PAUSED,
	GAME_OVER
}

# =============================================================================
# TURN PHASES
# =============================================================================
enum TurnPhase {
	SETUP,
	PLANNING,
	REVEAL_SPEED,
	ACTION,
	ROUND_END
}

# =============================================================================
# TERRAIN TYPES
# =============================================================================
enum TerrainType {
	LAND,
	MEADOW,
	WATER,
	JUNGLE,
	MOUNTAIN,
	LAVA,
	SPIKE_PIT,
	WHIRLPOOL,
	ICE,
	QUICKSAND,
	VOID,
	SWAMP,
	BLIGHT
}

# =============================================================================
# GAME SETTINGS
# =============================================================================
const MAX_PLAYERS: int = 4
const MIN_PLAYERS: int = 2
const DICE_COUNT: int = 5
const DICE_SIDES: int = 6
const WAYSTONE_WIN_COUNT: int = 4

# Movement costs per terrain type
const TERRAIN_MOVE_COSTS: Dictionary = {
	TerrainType.LAND: 1,
	TerrainType.MEADOW: 1,
	TerrainType.WATER: 2,
	TerrainType.JUNGLE: 2,
	TerrainType.MOUNTAIN: 2,
	TerrainType.LAVA: 1,
	TerrainType.SPIKE_PIT: 1,
	TerrainType.WHIRLPOOL: 1,
	TerrainType.ICE: 1,
	TerrainType.QUICKSAND: 1,
	TerrainType.SWAMP: 3,
	TerrainType.BLIGHT: 1
}

# Terrain that blocks line of sight
const LOS_BLOCKING_TERRAIN: Array = [
	TerrainType.MOUNTAIN,
	TerrainType.VOID
]

# =============================================================================
# SCENE PATHS
# =============================================================================
const SCENE_MAIN_MENU: String = "res://scenes/Menu/MainMenu.tscn"
const SCENE_GAME: String = "res://scenes/Game/GameRoot.tscn"

# =============================================================================
# CURRENT GAME STATE
# =============================================================================
var current_state: GameState = GameState.NONE
var current_player_count: int = 2
var debug_mode: bool = true

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================
func get_terrain_cost(terrain: TerrainType) -> int:
	return TERRAIN_MOVE_COSTS.get(terrain, 1)

func does_terrain_block_los(terrain: TerrainType) -> bool:
	return terrain in LOS_BLOCKING_TERRAIN

func set_game_state(new_state: GameState) -> void:
	var old_state = current_state
	current_state = new_state
	GameSignals.game_state_changed.emit(old_state, new_state)

func _ready() -> void:
	if debug_mode:
		print("[GameConfig] Initialized")
