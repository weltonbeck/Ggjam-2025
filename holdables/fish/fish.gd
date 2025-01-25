extends Holdable

@export var move = true
@export var speed = 150
@export var face_to_right = true

var direction:Vector2 = Vector2.LEFT

func _ready() -> void:
	if face_to_right:
		flip()

func _process(delta: float) -> void:
	if move:
		translate(direction * delta * speed)

func flip() -> void:
	$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
	direction *= -1


func hold(new_parent:Node2D) -> void:
	move = false
	super(new_parent)


func _on_body_entered(_body: Node2D) -> void:
	flip()
