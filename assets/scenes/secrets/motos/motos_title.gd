extends Node2D

signal motos_progress
var title_progress := false

var color_change := 0.0

func _ready():
	await get_tree().create_timer(1.3).timeout
	$Startup/ramok.visible = true
	await get_tree().create_timer(0.3).timeout
	$Startup/romok.visible = true
	await get_tree().create_timer(1.3).timeout
	$Startup.visible = false
	title_sequence()

func _physics_process(delta):
	color_change += 1/360.0
	if color_change > 1.0:
		color_change = 0/360.0
	$grid.modulate = Color.from_hsv(color_change, 0.5, 0.5, 1)

func title_sequence():
	$Sounds/musTitleTheme.play()
	while !title_progress:
		if Input.is_action_just_pressed("MotosJump"):
			title_progress = true
		await get_tree().create_timer(0.01).timeout
	$howtoplay.visible = false
	$credit.text = "Credits 1"
	$Sounds/musTitleTheme.stop()
	$Sounds/sfxStart.play()

func _on_sfx_start_finished():
	motos_progress.emit("mStage1", false)
