extends Node2D


func _on_button_start_button_down() -> void:
	GameManager.go_to_level_one()


func _on_button_credits_button_down() -> void:
	GameManager.go_to_level_credits()
