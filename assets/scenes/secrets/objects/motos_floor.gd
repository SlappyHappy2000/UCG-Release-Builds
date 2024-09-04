extends Marker2D

var pit = preload("res://assets/scenes/secrets/objects/motos_pitfall.tscn")

func _ready():
	modulate = Color.from_hsv(randf_range(0.0, 1.0), 0.5, 1.0, 0.75)

func _physics_process(delta):
	pass

func pitfall():
	$Sounds/sfxDestroy.play()
	$Sounds/sfxDestroy2.play()
	$AnimatedSprite2D.play()

func _on_animated_sprite_2d_animation_finished():
	var p = pit.instantiate()
	p.global_position = global_position
	get_parent().get_parent().get_node("MotosPit").add_child(p)
	queue_free()
