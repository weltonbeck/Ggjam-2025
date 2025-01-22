extends Area2D

const MIN_SCALE = 0.25
const MAX_SCALE = 1.5
const EXPLODE_SCALE = 2.5
const MIN_SPEED = 30
const MAX_SPEED = 200

var speed: float = 100.0
var is_able_to_move = false
var is_holding_something = false
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	scale = Vector2(MIN_SCALE, MIN_SCALE)


func _process(delta) -> void:
	if (is_able_to_move):
		translate(direction * speed * delta)


func increase_scale(mor_scale:float) -> void:
	if scale.x >= MAX_SCALE:
		scale = Vector2(MAX_SCALE,MAX_SCALE)
	else:
		scale += Vector2(mor_scale,mor_scale)
	if !is_holding_something:
		speed = clamp((MAX_SCALE - scale.x) * (MAX_SPEED / MAX_SCALE), MIN_SPEED, MAX_SPEED)


func start_move() -> void:
	if $AnimationPlayer.is_playing() :
		await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("move") 
	is_able_to_move = true


func explode() -> void:
	is_able_to_move = false
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	call_deferred("queue_free")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bubbles"):
			if scale.x > area.scale.x and scale.x < EXPLODE_SCALE:
				print(area.scale / MAX_SCALE)
				scale += area.scale / MAX_SCALE
			else:
				explode()

	elif area.is_in_group("Floatable"):
		is_holding_something = true
		is_able_to_move = false
		speed = 100
		direction = Vector2.UP
		area.global_position = $CenterMarker.global_position
		area.call_deferred("reparent", self)
		area.set_deferred("monitorable", false)
		area.scale = Vector2(.8,.8)
		area.z_index = -1
		await get_tree().create_timer(.2).timeout
		is_able_to_move = true
		
	else:
		explode()
