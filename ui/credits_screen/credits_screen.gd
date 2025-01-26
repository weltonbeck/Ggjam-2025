extends Node2D

@onready var click: AudioStreamPlayer = $CanvasLayer/ButtonBack/Click

func _ready() -> void:
	GameManager.play_music("credits")


func _on_button_back_button_down() -> void:
	click.play()
	GameManager.go_to_title_game()
