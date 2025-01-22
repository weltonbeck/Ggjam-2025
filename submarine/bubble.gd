extends Area2D

@export var speed: float = 100.0

var is_able_to_move = false
var direction: Vector2 = Vector2.RIGHT

var initial_scale: Vector2 = Vector2(0.25,0.25)

const MAX_SCALE = 1.5

func _ready() -> void:
	scale = initial_scale

func _process(delta) -> void:
	if (is_able_to_move):
		translate(direction * speed * delta)

func increase_scale(mor_scale:float) -> void:
	if scale.x >= MAX_SCALE:
		scale = Vector2(MAX_SCALE,MAX_SCALE)
	else:
		scale += Vector2(mor_scale,mor_scale)
		
	if scale.x >= MAX_SCALE:
		speed = 100
	elif scale.x >= 1:
		speed = 150
	else: 
		speed = 250

func start_move() -> void:
	if $AnimationPlayer.is_playing() :
		await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("move") 
	is_able_to_move = true


func explode() -> void:
	is_able_to_move = false
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bubbles"):
		explode()
