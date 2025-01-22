extends CharacterBody2D

const WATER_FRICTION = 0.5

@export var speed = 200.0
@export var bullet: PackedScene

var instance_bullet
var able_to_shoot = true
var shooting_pressed = false
var shooting_released = false
var delay_shoot = 0.3
var delay_shoot_buffer = 0


func _physics_process(delta: float) -> void:
	walk()
	
	shoot(delta)
	
	move_and_slide()


func walk() -> void:
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	
	if direction_x:
		velocity.x = lerp(velocity.x, direction_x * speed, WATER_FRICTION)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if direction_y:
		velocity.y = lerp(velocity.y, direction_y * speed, WATER_FRICTION)
	else:
		velocity.y = move_toward(velocity.y, 0, speed)


func shoot(delta) -> void:
	
	if Input.is_action_just_pressed("ui_shoot") :
		shooting_pressed = true
		shooting_released = false
	if Input.is_action_just_released("ui_shoot"):
		shooting_released = true
				
	if shooting_pressed && able_to_shoot && instance_bullet == null:
			instance_bullet = bullet.instantiate()
			instance_bullet.global_position = $BulletSpawnerMarker.global_position
			get_tree().root.add_child(instance_bullet)
			shooting_pressed = false
			
	if able_to_shoot && instance_bullet &&  is_instance_valid(instance_bullet):
		instance_bullet.global_position = $BulletSpawnerMarker.global_position
		if instance_bullet.has_method("increase_scale"):
			instance_bullet.increase_scale(delta/2)
				
	if shooting_released && able_to_shoot:
		if instance_bullet && is_instance_valid(instance_bullet) && instance_bullet.has_method("start_move"):
			able_to_shoot = false
			instance_bullet.start_move()
			instance_bullet = null
			shooting_released = false
	
	if !able_to_shoot:
		delay_shoot_buffer += delta
		if delay_shoot_buffer >= delay_shoot:
			able_to_shoot = true
			delay_shoot_buffer = 0
	
