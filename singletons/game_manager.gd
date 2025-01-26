extends Node2D

@onready var transition = $ScreenTransition
@onready var music: AudioStreamPlayer = $Music
var musics: Dictionary = {
	"level":load("res://music/level.mp3"),
	"menu":load("res://music/menu.mp3"),
	"credits":load("res://music/credits.mp3")
}

signal treasure_is_resgated()


func _ready() -> void:
	play_music("menu")
func set_treasure_resgate() -> void:
	treasure_is_resgated.emit()

func go_to_title_game()-> void:
	await change_scene("res://ui/title_screen/title_screen.tscn")

func go_to_level_credits()-> void:
	await change_scene("res://ui/credits_screen/credits_screen.tscn")

func go_to_level_one()-> void:
	await change_scene("res://levels/one.tscn")
	
func change_scene(new_scene: String) -> void:
	await transition.close()
	get_tree().change_scene_to_file(new_scene)
	await get_tree().process_frame
	await get_tree().create_timer(0.2).timeout
	await transition.open()
	
func play_music(type: String):
	music.stream = musics[type.to_lower()]
	if music.stream:
		music.play()

func stop_music():
	music.stop()
