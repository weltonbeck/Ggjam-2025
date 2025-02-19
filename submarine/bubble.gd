extends CharacterBody2D
class_name Bubble

const WATER_FRICTION = 0.5
const MIN_SCALE = 1.0
const MAX_SCALE = 1.5

@export var disappear_effect: PackedScene
const EXPLODE_SCALE = 2.5

var is_active = false
var is_being_pushed = false
@export var default_speed: float = 600.0
@onready var speed = default_speed
@onready var pop: AudioStreamPlayer = $Pop
@onready var catching: AudioStreamPlayer = $Catching

var is_able_to_move = false
var face_is_right = true
var direction: Vector2 = Vector2.RIGHT

var is_holding_something = false
var holding_object

var is_pushing_something = false
var pushing_object

func _ready() -> void:
	scale = Vector2(MIN_SCALE, MIN_SCALE)

func _physics_process(_delta: float) -> void:
	
	velocity.x = lerp(velocity.x, direction.x * speed, WATER_FRICTION)
	velocity.y = lerp(velocity.y, direction.y * speed, WATER_FRICTION)
	
	if (is_able_to_move):	
		move_and_slide()

func flip(new_face_is_right:bool):
	face_is_right = new_face_is_right
	var new_scale =  Vector2(1,1)
	if !face_is_right:
		new_scale = Vector2(-1,1)
	$Sprite.scale = new_scale
	if face_is_right :
		$Area2D/CollisionShape2D.position.x = 125
		$CollisionShape2D.position.x = 125
	else:
		$Area2D/CollisionShape2D.position.x = -125
		$CollisionShape2D.position.x = -125


func increase_scale(mor_scale:float) -> void:
	if !is_active:
		if scale.x >= MAX_SCALE:
			scale = Vector2(MAX_SCALE,MAX_SCALE)
		else:
			scale += Vector2(mor_scale,mor_scale)


func start_move(new_direction:Vector2) -> void:
	direction = new_direction
	if $AnimationPlayer.is_playing() :
		await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("move")
	is_able_to_move = true
	is_active = true


func explode() -> void:	
	is_able_to_move = false
	
	if !is_holding_something || !holding_object || !holding_object.has_method("drop"):
		pop.play()
		$AnimationPlayer.play("explode")
		await $AnimationPlayer.animation_finished
		call_deferred("queue_free")


func hold(area:Area2D) -> void:
	if !is_active:
		start_move(Vector2.ZERO)
		
	if is_active && is_able_to_move && !is_holding_something && area.has_method("hold") && area.min_bubble_size <= scale.x:
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
		direction = Vector2.UP
		is_able_to_move = true
		disappear()
	elif area != holding_object:
		explode()

func disappear() -> void:
	await get_tree().create_timer(.5).timeout
	if disappear_effect:
		catching.play()
		var instance_disappear_effect = disappear_effect.instantiate()
		instance_disappear_effect.scale = scale
		instance_disappear_effect.global_position = $Area2D/CollisionShape2D.global_position
		get_tree().root.add_child(instance_disappear_effect)
	GameManager.set_treasure_resgate()
	hide()
	await get_tree().create_timer(.2).timeout
	call_deferred("queue_free")
	
func push(body:Node2D)->void:
	is_pushing_something = true
	if is_active && is_instance_valid(body) && body.is_in_group("Pushable") && body.has_method("push"):
		body.push(self)
		pushing_object = body

func pushed(move_direction, new_position=global_position):
	new_position.x += ( -125 * scale.x) if face_is_right else 125 * scale.x
	if move_direction != Vector2.ZERO:
		if is_active:
			var tween = create_tween()
			if scale.x <= MAX_SCALE:
				tween.tween_property(self, "scale",Vector2(1,1), 0.01)
			if move_direction.x != 0:
				tween.tween_property(self, "global_position:y", new_position.y, 0.2)
			else:
				tween.tween_property(self, "global_position:x", new_position.x, 0.2)
			await tween.finished
			direction = move_direction
			speed = 800
		else:
			explode()
	else:
		speed = default_speed


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bubbles"):
		if !is_active:
			start_move(area.get_parent().direction)
		if (scale.x > area.get_parent().scale.x || (scale.x == area.get_parent().scale.x && get_instance_id() < area.get_parent().get_instance_id()) ) && scale.x < EXPLODE_SCALE && !is_holding_something :
			$AnimationPlayer.play("fusion")
			scale += Vector2(0.5,0.5)
			if is_pushing_something && pushing_object:
				push(pushing_object)
		elif !is_pushing_something && !pushing_object:
			explode()
	
	elif area.is_in_group("Holdable"):
		hold(area)
		
	else:
		explode()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hazard") && !is_pushing_something:
		explode()
	if is_active && body.is_in_group("Pushable"):
		push(body)
