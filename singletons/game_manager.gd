extends Node2D

@onready var transition = $ScreenTransition


signal treasure_is_resgated()

func set_treasure_resgate() -> void:
	treasure_is_resgated.emit()

func go_to_title_game()-> void:
	await change_scene("res://levels/level_title.tscn")

func go_to_level_credits()-> void:
	await change_scene("res://levels/level_credits.tscn")

func go_to_level_one()-> void:
	await change_scene("res://levels/level_one.tscn")
	
func change_scene(new_scene: String) -> void:
	await transition.close()
	get_tree().change_scene_to_file(new_scene)
	await get_tree().process_frame
	await get_tree().create_timer(0.2).timeout
	await transition.open()
