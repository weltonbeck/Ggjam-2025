extends CanvasLayer


func _ready() -> void:
	hide()


func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	GameManager.change_scene(get_tree().current_scene.scene_file_path)


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	GameManager.go_to_title_game()


func handle_pause(paused: bool):
	if paused:
		show()
	else:
		hide()
