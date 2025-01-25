extends Area2D

@export var direction:Vector2
@export var invert_on_hurt = true



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bubbles"):
		area.get_parent().direction = direction
		if invert_on_hurt:
			$AnimatedSprite2D.play("hurt")
			await $AnimatedSprite2D.animation_finished
			direction *= -1
			scale.x = scale.x * -1
			$AnimatedSprite2D.play("idle")
