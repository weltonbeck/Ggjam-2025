extends CharacterBody2D

const WATER_FRICTION = 0.5

@export var use_gravity = true
@export var min_bubble_size = 1.0
@export var allow_rotation = false
@export var rotation_element:Node2D
@onready var hit: AudioStreamPlayer = $Hit

var is_pushed = false
var speed = 200.0
var direction = Vector2.RIGHT

var bubble_push:Node2D

func _physics_process(delta: float) -> void:
	
	if is_pushed &&  direction.x != 0:
		velocity.x = lerp(velocity.x, direction.x * speed, WATER_FRICTION)
		if allow_rotation && rotation_element:
			rotation_element.rotation += delta
		if is_on_wall():
			is_pushed = false
			direction = Vector2.ZERO
			
	if is_pushed &&  direction.y != 0 && !is_on_ceiling():
		velocity.y = lerp(velocity.y, direction.y * speed, WATER_FRICTION)
		if bubble_push && ! is_instance_valid(bubble_push):
			is_pushed = false
			direction = Vector2.ZERO
		
	if use_gravity && ! is_on_floor() &&  direction.y != -1:
		velocity += get_gravity() * delta

	move_and_slide()

func push(bubble:Bubble) -> void:
	if bubble && bubble.scale.x >= min_bubble_size:
		hit.play()
		direction = bubble.direction
		is_pushed = true
		bubble_push = bubble
	
