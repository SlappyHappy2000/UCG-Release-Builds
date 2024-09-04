extends Node2D

signal progress

func _ready():
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1))
	$sfxJingle.play()

func _physics_process(delta):
	if Input.is_action_just_pressed("Click"):
		progress.emit("title", 3)
