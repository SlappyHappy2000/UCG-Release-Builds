extends CharacterBody2D

signal die

var bashable := false
var bashed := false

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta * scale)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
	if !bashed and Input.is_action_just_pressed("Click") and bashable:
		hit()

func hit():
	bashed = true
	velocity = Vector2.ZERO
	die.emit()
	$Sounds/sfxOw.play()
	$spr_bart.visible = false
	$spr_explode.visible = true
	$spr_explode.play()

func _on_spr_explode_animation_finished():
	queue_free()

func _on_mouse_entered():
	bashable = true

func _on_mouse_exited():
	bashable = false
