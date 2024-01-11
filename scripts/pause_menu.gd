extends Control

@export var game_manager: GameManager

func _ready():
	hide()
	game_manager.connect("toggle_game_pause", _on_game_manager_toggle_game_paused)

func _input(event:InputEvent):
	if event.is_action_pressed("ui_cancel"):
		hide()


func _on_quit_pressed():
	get_tree().quit()


func _on_game_manager_toggle_game_paused(is_paused: bool):
	if(is_paused):
		show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_resume_pressed():
	game_manager.game_paused = false
