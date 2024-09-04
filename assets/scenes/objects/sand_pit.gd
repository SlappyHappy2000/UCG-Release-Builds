extends Area2D

func _ready():
	$CollisionPolygon2D.polygon = $Polygon2D.polygon

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body.get_collision_layer_value(2):
			body.velocity = lerp(body.velocity, Vector2.ZERO, 0.15)
		elif body.get_collision_layer_value(4):
			pass
