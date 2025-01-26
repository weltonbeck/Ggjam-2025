extends Area2D


@export var invert_on_hurt = true
@onready var hurt: AudioStreamPlayer = $Hurt
var direction: Vector2

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bubbles"):
		if area.get_parent().direction.y == 1:
			direction = Vector2(scale.x *-1, 0)
		if area.get_parent().direction.x != 0:
			direction = Vector2(0, -1)

		area.get_parent().direction = direction
		hurt.play()
		$AnimatedSprite2D.play("hurt")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("idle")
		if invert_on_hurt:
			direction *= -1
			scale.x = scale.x * -1
	
