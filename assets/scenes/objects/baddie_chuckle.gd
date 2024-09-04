extends CharacterBody2D
class_name BaddieChuckle

@export var speed_multiplier := 0.35
@export var speed_limit := 40.0

var target : CharacterBody2D = null

signal collected

func _ready():
	$AnimatedSprite2D.play()

func _physics_process(delta):
	if global_position.x < 128 or global_position.x > 896 or global_position.y < -128 or global_position.y > 640:
		queue_free()
	
	var direction := (target.global_position - global_position).normalized()
	velocity += direction * speed_multiplier
	velocity = velocity.limit_length(speed_limit)
	
	var collision_info = move_and_collide(velocity * delta  * scale)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())

func hit():
	collected.emit(50, "DChuckle")
	queue_free()
