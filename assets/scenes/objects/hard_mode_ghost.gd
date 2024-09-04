extends CharacterBody2D

@export var options : Options

var speed_multiplier := 0.35
var speed_limit := 40.0

#hard mode values
#multiplier = 2.0
#limit = 150.0

var target : CharacterBody2D = null

signal caught

func _ready():
	if options.multiplayer_active or options.modifier_easymode:
		queue_free()
		return
	if options.modifier_hardmode:
		speed_multiplier = 2.0
		speed_limit = 150.0
		if options.modifier_roleswap:
			get_node("Sprite2D").texture = load("res://assets/graphics/ultracanny.png")
		else:
			get_node("Sprite2D").texture = load("res://assets/graphics/ultrauncanny.png")
	elif options.modifier_roleswap:
		get_node("Sprite2D").texture = load("res://assets/graphics/canny.png")

func _physics_process(delta):
	var direction := (target.global_position - global_position).normalized()
	velocity += direction * speed_multiplier
	velocity = velocity.limit_length(speed_limit)
	
	var collision_info = move_and_collide(velocity * delta * scale)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
	#if global_position.y > target.global_position.y:
		#velocity.y -= 0.25
		#if velocity.y < -30:
			#velocity.y = -30
	#elif global_position.y < target.global_position.y:
		#velocity.y += 0.25
		#if velocity.y > 30:
			#velocity.y = 30
	#if global_position.x > target.global_position.x:
		#velocity.x -= 0.25
		#if velocity.x < -30:
			#velocity.x = -30
	#elif global_position.x < target.global_position.x:
		#velocity.x += 0.25
		#if velocity.x > 30:
			#velocity.x = 30

func _on_area_2d_body_entered(body):
	caught.emit("nothing")
	queue_free()
