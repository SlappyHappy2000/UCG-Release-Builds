extends CharacterBody2D

signal win

var already_collected := false

var acceleration := Vector2.ZERO

var active := true

const MAX_SPEED = 300
const RAYLENGTH = 100
const WALL_FORCE = 5000
const PLAYER_FORCE = 100000

signal collected

func _ready():
	velocity = Vector2(1, 2.3)
	$Raycasts/N.target_position = Vector2(0, -RAYLENGTH)
	$Raycasts/NW.target_position = Vector2(-RAYLENGTH*0.5*sqrt(2), -RAYLENGTH*0.5*sqrt(2))
	$Raycasts/W.target_position = Vector2(-RAYLENGTH, 0)
	$Raycasts/SW.target_position = Vector2(-RAYLENGTH*0.5*sqrt(2), RAYLENGTH*0.5*sqrt(2))
	$Raycasts/S.target_position = Vector2(0, RAYLENGTH)
	$Raycasts/SE.target_position = Vector2(RAYLENGTH*0.5*sqrt(2), RAYLENGTH*0.5*sqrt(2))
	$Raycasts/E.target_position = Vector2(RAYLENGTH, 0)
	$Raycasts/NE.target_position = Vector2(RAYLENGTH*0.5*sqrt(2), -RAYLENGTH*0.5*sqrt(2))
	$Flag.play()

func _physics_process(delta):
	if active:
		for raycast in $Raycasts.get_children():
			if raycast.is_colliding():
				add_repulsion(raycast.get_collision_point(), WALL_FORCE)
		
		velocity = velocity.normalized() * MAX_SPEED
		
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func add_repulsion(pos : Vector2, strength : float):
	var distance = pos - global_position
	var d = 1.0 / distance.length_squared()
	velocity -= strength * d * distance.normalized()

func _on_goal_hitbox_body_entered(body):
	if already_collected:
		return
	win.emit()
	active = false
	already_collected = true
