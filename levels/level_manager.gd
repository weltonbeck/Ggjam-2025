extends Node2D

@export var next_level:PackedScene
@export var treasures_in_level = 1

var treasures_resgated = 0

func _ready() -> void:
	GameManager.treasure_is_resgated.connect(treasure_is_resgated)

func treasure_is_resgated() -> void:
	treasures_resgated += 1
	if treasures_resgated == treasures_in_level :
		await get_tree().create_timer(.2).timeout
		GameManager.change_scene(next_level.resource_path)
