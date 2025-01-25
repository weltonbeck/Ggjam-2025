extends Node2D
class_name Holdable

@export var min_bubble_size = 1.0

@export var move = true
@export var speed = 150
@export var face_to_right = true

var direction:Vector2 = Vector2.LEFT

var is_holded = false

func _ready() -> void:
	if face_to_right:
		flip()
	

func _process(delta: float) -> void:
	if move:
		translate(direction * delta * speed)

func flip() -> void:
	if move:
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
		direction *= -1

func hold(new_parent:Node2D) -> void:
	move = false
	set_deferred("monitorable", false)
	call_deferred("reparent", new_parent)
	var tween = get_tree().create_tween()
	var new_scale = 100 / (new_parent.scale.x * 100)
	tween.tween_property(self, "scale", Vector2(new_scale,new_scale),0.1)
	z_index = -1
	is_holded = true


func drop() -> void:
	call_deferred("reparent", get_tree().root)
	set_deferred("monitorable", true)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1,1),0.1)
	is_holded = false


func _on_body_entered(_body: Node2D) -> void:
	flip()
