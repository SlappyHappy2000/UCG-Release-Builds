extends CharacterBody2D
class_name MotosObject

var target : CharacterBody2D = null

var playmode := false
@export var mass := 0.0
@export var speed := 0.0
@export var score_value := 0
var knockback_timer := 0

@export var bump_sound : String

signal died

func _ready():
	pass

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta * scale)
	
	if collision_info:
		collide_with_player(collision_info.get_collider())
		collision_info.get_collider().collide_with_player(self)

func collide_with_player(other):
	velocity = other.global_position.direction_to(global_position) * speed * other.mass / mass
	knockback_timer = 20
	$Sounds/sfxBump.play()

func death():
	velocity = Vector2.ZERO
	playmode = false
	$Sounds/sfxFall.play()
	while scale > Vector2(0.2, 0.2):
		scale -= Vector2(0.01, 0.01)
		await get_tree().create_timer(0.01).timeout
	died.emit(score_value)
	$Sprite2D.visible = false
	
