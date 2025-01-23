extends Area2D

const MIN_SCALE = 0.5
const MAX_SCALE = 1.0

const EXPLODE_SCALE = 2.5
const MIN_SPEED = 100
const MAX_SPEED = 400

var is_active = false

var speed: float = 100.0
var is_able_to_move = false
var face_is_right = true
var direction: Vector2 = Vector2.RIGHT

var is_holding_something = false
var holding_object


func _ready() -> void:
	scale = Vector2(MIN_SCALE, MIN_SCALE)


func _process(delta) -> void:
	if (is_able_to_move):
		translate(direction * speed * delta)

func flip(new_face_is_right:bool):
	face_is_right = new_face_is_right
	var new_scale =  Vector2(1,1)
	if !face_is_right:
		new_scale = Vector2(-1,1)
	$Content.scale = new_scale
	if face_is_right :
		$CollisionShape2D.position.x = 125
	else:
		$CollisionShape2D.position.x = -125


func increase_scale(mor_scale:float) -> void:
	if scale.x >= MAX_SCALE:
		scale = Vector2(MAX_SCALE,MAX_SCALE)
	else:
		scale += Vector2(mor_scale,mor_scale)
	if !is_holding_something:
		speed = clamp((MAX_SCALE - scale.x) * (MAX_SPEED / MAX_SCALE), MIN_SPEED, MAX_SPEED)


func start_move(new_direction:Vector2) -> void:
	direction = new_direction
	if $AnimationPlayer.is_playing() :
		await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("move")
	is_able_to_move = true
	is_active = true


func explode() -> void:
	is_able_to_move = false
	
	if is_holding_something && holding_object && holding_object.has_method("drop"):
		holding_object.drop()
	
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	call_deferred("queue_free")


func hold(area:Area2D) -> void:
	if is_able_to_move && !is_holding_something && area.has_method("hold") && area.min_bubble_size <= scale.x:
		is_holding_something = true
		is_able_to_move = false
		$AnimationPlayer.play("fusion")
		var new_position = area.global_position - ($RightCenterMarker2D.position * scale)
		if !face_is_right:
			new_position = area.global_position - ($LeftCenterMarker2D.position * scale)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position",new_position, 0.01)
		await tween.finished
		area.hold(self)
		holding_object = area
		await get_tree().create_timer(.2).timeout
		speed = 200
		direction = Vector2.UP
		is_able_to_move = true
	elif area != holding_object:
		explode()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if is_active && area.is_in_group("Bubbles"):
		if scale.x > area.scale.x && scale.x < EXPLODE_SCALE && !is_holding_something :
			$AnimationPlayer.play("fusion")
			scale += area.scale / MAX_SCALE
		else:
			explode()
	
	elif is_active && area.is_in_group("Holdable"):
		hold(area)
		
	else:
		explode()
