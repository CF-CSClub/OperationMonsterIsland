extends Control
## Main Menu screen - entry point for the game.

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var player_count_spin: SpinBox = $VBoxContainer/PlayerCountContainer/PlayerCountSpin


func _ready() -> void:
	# Connect button signals
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# Initialize player count
	player_count_spin.min_value = GameConfig.MIN_PLAYERS
	player_count_spin.max_value = GameConfig.MAX_PLAYERS
	player_count_spin.value = GameConfig.current_player_count
	
	if GameConfig.debug_mode:
		print("[MainMenu] Ready")


func _on_start_pressed() -> void:
	# Update player count in config
	GameConfig.current_player_count = int(player_count_spin.value)
	
	# Find AppRoot and start game
	var app_root = get_node("/root/AppRoot")
	if app_root and app_root.has_method("start_game"):
		app_root.start_game()
	else:
		push_error("[MainMenu] Could not find AppRoot")


func _on_quit_pressed() -> void:
	get_tree().quit()
