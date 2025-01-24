extends Area2D

@export var direction:Vector2


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bubbles"):
		area.get_parent().direction = direction
