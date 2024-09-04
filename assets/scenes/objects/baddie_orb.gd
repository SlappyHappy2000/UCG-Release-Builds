extends CharacterBody2D

signal collected

@export var speed : int
@export var direction : Vector2

func _ready():
	velocity = speed * direction.normalized()
	$AnimatedSprite2D.play()

func _physics_process(delta):
	if global_position.x < 128 or global_position.x > 896 or global_position.y < -128 or global_position.y > 640:
		queue_free()
	
	var collision_info = move_and_collide(velocity * delta * scale)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())

func hit():
	collected.emit(50, "DBaddie")
	queue_free()
