extends MotosObject

var jump_timer := 0

func _ready():
	super._ready()

func _physics_process(delta):
	super._physics_process(delta)
	if jump_timer > 0:
		jump_timer -= 1
	
	if playmode:
		if knockback_timer > 0:
			knockback_timer -= 1
		else:
			if $AnimationPlayer.current_animation != "Jump":
				if jump_timer <= 0 and Input.is_action_just_pressed("MotosJump"):
					jump()
				else:
					velocity = Input.get_vector("left2", "right2", "up2", "down2") * speed
	

func jump():
	$AnimationPlayer.play("Jump")

func death():
	set_collision_layer_value(2, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(3, false)
	super.death()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Jump":
		pass
	pass
