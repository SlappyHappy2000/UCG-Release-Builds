extends Marker2D

signal collected

@export var spawn_rate : int

@export var car_speed : int
@export var car_direction : Vector2
@export var car_rotate : float
@export var car_color : Color
@export var car_scale : Vector2 = Vector2(1, 1)

var spawn_countdown := 0

func _physics_process(delta):
	spawn_countdown += 1
	if spawn_countdown > spawn_rate:
		var c = load("res://assets/scenes/objects/baddie_car.tscn").instantiate()
		c.scale = car_scale
		c.speed = car_speed
		c.direction = car_direction
		c.get_node("Sprite2D").rotation_degrees = car_rotate
		c.modulate = car_color
		c.global_position = global_position
		get_parent().add_child(c)
		c.collected.connect(get_parent().get_parent().obj_collision_sfx)
		spawn_countdown = 0

