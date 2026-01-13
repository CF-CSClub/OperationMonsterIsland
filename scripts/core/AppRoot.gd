extends Node
## Application root - manages scene loading and transitions.
## This is the main entry point of the application.

@onready var scene_container: Node = $SceneContainer
@onready var state_machine: GameStateMachine = $GameStateMachine

var _current_scene: Node = null
var _is_transitioning: bool = false


func _ready() -> void:
	# Connect to signals
	GameSignals.scene_change_requested.connect(_on_scene_change_requested)
	state_machine.state_entered.connect(_on_state_entered)
	
	# Load initial scene (MainMenu)
	_load_scene(GameConfig.SCENE_MAIN_MENU)
	
	if GameConfig.debug_mode:
		print("[AppRoot] Application initialized")


func _on_state_entered(state: GameConfig.GameState) -> void:
	match state:
		GameConfig.GameState.MAIN_MENU:
			_load_scene(GameConfig.SCENE_MAIN_MENU)
		GameConfig.GameState.IN_GAME:
			_load_scene(GameConfig.SCENE_GAME)


func _on_scene_change_requested(scene_path: String) -> void:
	_load_scene(scene_path)


func _load_scene(scene_path: String) -> void:
	if _is_transitioning:
		push_warning("[AppRoot] Scene transition already in progress")
		return
	
	_is_transitioning = true
	
	# Unload current scene
	if _current_scene:
		_current_scene.queue_free()
		_current_scene = null
	
	# Load new scene
	var packed_scene = load(scene_path)
	if packed_scene:
		_current_scene = packed_scene.instantiate()
		scene_container.add_child(_current_scene)
		
		var scene_name = scene_path.get_file().get_basename()
		GameSignals.scene_loaded.emit(scene_name)
		
		if GameConfig.debug_mode:
			print("[AppRoot] Loaded scene: %s" % scene_name)
	else:
		push_error("[AppRoot] Failed to load scene: %s" % scene_path)
	
	_is_transitioning = false


func start_game() -> void:
	state_machine.transition_to(GameConfig.GameState.IN_GAME)


func return_to_menu() -> void:
	state_machine.transition_to(GameConfig.GameState.MAIN_MENU)


func quit_game() -> void:
	get_tree().quit()
