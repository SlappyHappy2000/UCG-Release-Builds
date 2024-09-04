extends CharacterBody2D

@export var options : Options

signal spawned
signal hit_up

signal tv_p

const MAX_DRAG = 175
const DRAG_MULTIPLIER = 5
const DRAG_CANCEL = 20
const FRIC_COEFF = 0.04
const FRIC_POW = 1.06
const STOP_SPEED = 20

const HUE_WEAKEST = 0.69
const HUE_STRONGEST = 0

@export var state : Node

var glass_health := 3

func transition_to(target_state_name: String, type: int = 0):
	assert(has_node("States/" + target_state_name))
	state.exit()
	state = get_node("States/" + target_state_name)
	state.enter(type)
	state.update()

func _ready():
	state.enter()
	if options.multiplayer_active:
		$playermarker.visible = true
	if options.modifier_roleswap:
		get_node("Sprite2D").texture = load("res://assets/graphics/uncanny.png")
	for i in $Sounds.get_children():
		if options.settings_sound_volume == 0:
			i.volume_db = -80
		else:
			i.volume_db = -40 + (2 * options.settings_sound_volume)

func _physics_process(delta):
	state.update()
	$statedebug.text = str(state.name)
	
	var collision_info = move_and_collide(velocity * delta * scale)
	if collision_info:
		if (state == $States/CGMoving or (state == $States/CGMouseModifier and velocity.length() > 32)) and collision_info.get_collider().is_in_group("dblock"):
			collision_info.get_collider().hit()
			$Sounds/sfxWallBump.play()
		elif state == $States/CGMoving or (state == $States/CGMouseModifier and velocity.length() > 32):
			$Sounds/sfxWallBump.play()
			if options.modifier_glass:
				glass_health -= 1
				if glass_health == 0:
					owner.death("glass")
		else:
			if !$Sounds/sfxPush.is_playing():
				$Sounds/sfxPush.play()
		velocity = velocity.bounce(collision_info.get_normal())
