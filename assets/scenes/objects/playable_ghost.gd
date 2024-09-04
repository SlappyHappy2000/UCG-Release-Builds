extends CharacterBody2D

@export var options : Options

var speed_multiplier := 0.35
var speed_limit := 40.0

@export var player_id := 2

#hard mode values
#multiplier = 2.0
#limit = 150.0

signal caught

func _ready():
	if !options.multiplayer_active or options.multiplayer_players < player_id:
		queue_free()
		return
	
	$playermarker.frame = player_id - 1
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
	var direction := Input.get_vector("left" + str(player_id), "right" + str(player_id), "up" + str(player_id), "down" + str(player_id))
	direction = Vector2.ZERO if direction.length_squared() < 0.01 else direction.normalized()
	
	velocity += direction * speed_multiplier
	velocity = velocity.limit_length(speed_limit)
	
	var collision_info = move_and_collide(velocity * delta * scale)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())

func _on_area_2d_body_entered(body):
	caught.emit("nothing")
	queue_free()
