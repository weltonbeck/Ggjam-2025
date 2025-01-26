extends Node2D

@export var next_level:PackedScene
@export var treasures_in_level = 1
signal pause(paused: bool)

var treasures_resgated = 0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		set_pause()

func _ready() -> void:
	GameManager.play_music("level")
	GameManager.treasure_is_resgated.connect(treasure_is_resgated)


func treasure_is_resgated() -> void:
	treasures_resgated += 1
	if next_level and treasures_resgated == treasures_in_level :
		await get_tree().create_timer(.2).timeout
		GameManager.change_scene(next_level.resource_path)


func set_pause():
	pause.emit(!get_tree().paused)
	get_tree().paused = !get_tree().paused
