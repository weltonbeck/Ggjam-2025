extends CharacterBody2D

const WATER_FRICTION = 0.5

@export var speed = 300.0
@export var bullet: PackedScene

var instance_bullet
var can_shoot = true
var delay_shoot = 0.3
var delay_shoot_buffer = 0

func _physics_process(delta: float) -> void:
	walk()
	
	shoot(delta)
	
	move_and_slide()

func walk() -> void:
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	
	if direction_x:
		velocity.x = lerp(velocity.x, direction_x * speed, WATER_FRICTION)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if direction_y:
		velocity.y = lerp(velocity.y, direction_y * speed, WATER_FRICTION)
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
func shoot(delta) -> void:
	
	if can_shoot:
		if Input.is_action_just_pressed("ui_shoot") :
			instance_bullet = bullet.instantiate()
			instance_bullet.global_position = $BulletSpawnerMarker.global_position
			get_tree().root.add_child(instance_bullet)
		
		if Input.is_action_pressed("ui_shoot") && instance_bullet:
			instance_bullet.global_position = $BulletSpawnerMarker.global_position
			if instance_bullet && instance_bullet.has_method("increase_scale"):
				instance_bullet.increase_scale(delta/2)
		
		if Input.is_action_just_released("ui_shoot") && instance_bullet && instance_bullet.has_method("start_move"):
			instance_bullet.start_move()
			instance_bullet = null
			can_shoot = false
	else:
		delay_shoot_buffer += delta
		if delay_shoot_buffer >= delay_shoot:
			can_shoot = true
			delay_shoot_buffer = 0
		
