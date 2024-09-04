extends CharacterBody2D

signal collected

var already_collected := false
var floaty_pos := 0.0

func _ready():
	already_collected = false
	$AnimatedSprite2D.play()
	floaty_pos = global_position.y + 10

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if global_position.y > floaty_pos:
		velocity.y -= 1
	elif global_position.y < floaty_pos:
		velocity.y += 1

func _on_collision_area_body_entered(body):
	if already_collected:
		return
	collected.emit()
	already_collected = true
