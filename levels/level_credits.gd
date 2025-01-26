extends Node2D


func _ready() -> void:
	GameManager.play_music("credits")


func _on_button_back_button_down() -> void:
	GameManager.go_to_title_game()
