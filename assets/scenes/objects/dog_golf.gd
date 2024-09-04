extends CharacterBody2D

@export var options : Options

var winner := false

@export var speed : int
@export var direction : Vector2

func _ready():
	for i in $Sounds.get_children():
		if options.settings_sound_volume == 0:
			i.volume_db = -80
		else:
			i.volume_db = -40 + (2 * options.settings_sound_volume)
	velocity = speed * direction.normalized()

func _physics_process(delta):
	if winner:
		velocity = lerp(velocity, Vector2.ZERO, 0.05)
	
	var collision_info = move_and_collide(velocity * delta  * scale)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		if collision_info.get_collider().is_in_group("dblock"):
			collision_info.get_collider().hit()
			$Sounds/sfxWallBump.play()
		else:
			$Sounds/sfxWallBump.play()

