extends Node2D
class_name Holdable

@export var min_bubble_size = 1.0

var is_holded = false

func _ready() -> void:
	pass


func hold(new_parent:Node2D) -> void:
	set_deferred("monitorable", false)
	call_deferred("reparent", new_parent)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(.8,.8),0.1)
	z_index = -1
	is_holded = true


func drop() -> void:
	call_deferred("reparent", get_tree().root)
	set_deferred("monitorable", true)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1,1),0.1)
	is_holded = false
