extends Node2D

@export var next_level:PackedScene
@export var treasures_in_level = 1
signal pause(paused: bool)
@onready var tresure_count: Label = $LevelMenu/LabelContainer/TresureCount
@onready var total_tresures: Label = $LevelMenu/LabelContainer/TotalTresures

var treasures_resgated = 0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		set_pause()

func _ready() -> void:
	if get_tree().paused:
		set_pause()

	total_tresures.text = " / %s" % treasures_in_level
	GameManager.play_music("level")
	GameManager.treasure_is_resgated.connect(treasure_is_resgated)


func treasure_is_resgated() -> void:
	treasures_resgated += 1
	if next_level and treasures_resgated == treasures_in_level :
		await get_tree().create_timer(.2).timeout
		GameManager.change_scene(next_level.resource_path)
	tresure_count.text = str(treasures_resgated)

func set_pause():
	pause.emit(!get_tree().paused)
	get_tree().paused = !get_tree().paused
