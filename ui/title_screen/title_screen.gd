extends Node2D
@onready var click: AudioStreamPlayer = $Click


func _ready() -> void:
	GameManager.play_music("menu")

func _on_button_start_button_down() -> void:
	click.play()
	GameManager.go_to_level_one()


func _on_button_credits_button_down() -> void:
	click.play()
	GameManager.go_to_level_credits()
