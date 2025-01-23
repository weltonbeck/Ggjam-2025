extends CharacterBody2D

const WATER_FRICTION = 0.5

@export var speed = 250.0
@export var bullet: PackedScene

var face_is_right = true

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
	if direction_x != 0:
			face_is_right = direction_x == 1
			$Sprite2D.flip_h = !face_is_right
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
	
	var bubble_position = $RightBulletSpawnerMarker.global_position
	var bubble_direction = Vector2.RIGHT
	if !face_is_right :
		bubble_position = $LeftBulletSpawnerMarker2.global_position
		bubble_direction = Vector2.LEFT
			
	if shooting_pressed && able_to_shoot && instance_bullet == null:
			instance_bullet = bullet.instantiate()
			instance_bullet.global_position = bubble_position
			get_tree().root.add_child(instance_bullet)
			shooting_pressed = false
			if instance_bullet.has_method("flip"):
				instance_bullet.flip(face_is_right)
			
	if able_to_shoot && instance_bullet &&  is_instance_valid(instance_bullet):
		instance_bullet.global_position = bubble_position
		if instance_bullet.has_method("increase_scale") &&  instance_bullet.has_method("flip"):
			instance_bullet.increase_scale(delta/2)
			instance_bullet.flip(face_is_right)
				
	if shooting_released && able_to_shoot:
		if instance_bullet && is_instance_valid(instance_bullet) && instance_bullet.has_method("start_move"):
			able_to_shoot = false
			instance_bullet.start_move(bubble_direction)
			instance_bullet = null
			shooting_released = false
	
	if !able_to_shoot:
		delay_shoot_buffer += delta
		if delay_shoot_buffer >= delay_shoot:
			able_to_shoot = true
			delay_shoot_buffer = 0
	
