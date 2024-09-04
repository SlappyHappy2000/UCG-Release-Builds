extends MotosObject

func _ready():
	super._ready()

func _physics_process(delta):
	super._physics_process(delta)
	if playmode:
		if knockback_timer > 0:
			knockback_timer -= 1
		else:
			var direction := target.global_position - global_position
			var angle := snappedf(direction.angle(), PI / 4)
			velocity = Vector2.RIGHT.rotated(angle) * speed

func death():
	set_collision_layer_value(3, false)
	set_collision_mask_value(2, false)
	set_collision_mask_value(3, false)
	super.death()
