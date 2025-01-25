extends Area2D

@export var stream_direction = Vector2.UP


func _ready() -> void:
	
	pass

func _on_area_entered(area: Node2D) -> void:
	if area.has_method("pushed"):
		area.pushed(stream_direction, global_position)


func _on_area_exited(area: Node2D) -> void:
	if area.has_method("pushed"):
		area.pushed(Vector2.ZERO)
