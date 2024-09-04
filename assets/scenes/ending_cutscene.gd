extends Node2D

signal progress

var progression_timer := 0

#442 is time spent in frames getting to a certain point of the song... 7.38 seconds
func _ready():
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1))
	while progression_timer < 70:
		progression_timer += 1
		await get_tree().create_timer(0.1).timeout

func _physics_process(delta):
	if Input.is_action_just_pressed("Pause"):
		progress.emit("title", 0)
	if progression_timer >= 70:
		$bg.global_position.y += 0.4
