extends Node2D

@export var options : Options
@export var progress_destination : String

signal progress

var just_clicked := false

func _ready():
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1))
	for i in $Sounds.get_children():
		if options.settings_music_volume == 0:
			i.volume_db = -80
		else:
			i.volume_db = -40 + (2 * options.settings_music_volume)
	$Sounds/sfxCompleteJingle.play()

func _physics_process(delta):
	if Input.is_action_just_pressed("Click"):
		just_clicked = true
		if $Sounds/sfxCompleteJingle.playing:
			$Sounds/sfxCompleteJingle.stop()
			_on_sfx_complete_jingle_finished()

func _on_sfx_complete_jingle_finished():
	$Sounds/sfxOntoTheme.play()
	while global_position.y > -512:
		global_position.y = lerp(global_position.y, -516.0, 0.05)
		await get_tree().create_timer(0.01).timeout
	just_clicked = false
	while !just_clicked:
		await get_tree().create_timer(0.1).timeout
	just_clicked = false
	await get_tree().create_timer(0.1).timeout
	progress.emit(progress_destination, 0)
