extends Marker2D

signal collected

@export var spawn_rate : int

@export var chuckle_speed_multiplier : float
@export var chuckle_speed_limit : float
@export var chuckle_color : Color
@export var chuckle_scale : Vector2 = Vector2(1, 1)

var spawn_countdown := 0

func _ready():
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.modulate = chuckle_color

func _physics_process(delta):
	spawn_countdown += 1
	if spawn_countdown > spawn_rate:
		var c = load("res://assets/scenes/objects/baddie_chuckle.tscn").instantiate()
		c.target = get_parent().get_parent().get_node("MainObjects").get_node("CatGolf")
		c.name = "BaddieChuckle"
		c.scale = chuckle_scale
		c.speed_multiplier = chuckle_speed_multiplier
		c.speed_limit = chuckle_speed_limit
		c.modulate = chuckle_color
		c.global_position = global_position
		get_parent().add_child(c)
		c.collected.connect(get_parent().get_parent().obj_collision_sfx)
		spawn_countdown = 0
