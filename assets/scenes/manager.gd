extends Control

var global_time := false

var total_score := 0
var total_time_elapsed := 0.0
var total_resets := 0
var total_skips := 0

var multiplayer_score : Array[int] = [
	0,
	0,
	0,
	0
]

@export var options : Options

var thoughts_queue : String

const WORLD_LENGTHS : Array[int] = [
	5,
	15,
	15,
	15,
	5
]

var scenes := {
	"disclaimer" : preload("res://assets/scenes/pre_stage_cutscene.tscn"),
	"title" : preload("res://assets/scenes/titlescreen.tscn"),
	"options" : preload("res://assets/scenes/options_screen.tscn"),
	"onto1" : preload("res://assets/scenes/onto_world_1.tscn"),
	"onto2" : preload("res://assets/scenes/onto_world_2.tscn"),
	"onto3" : preload("res://assets/scenes/onto_world_3.tscn"),
	"onto4" : preload("res://assets/scenes/onto_world_4.tscn"),
	"secretbart" : preload("res://assets/scenes/secrets/bart_bash.tscn"),
	"secretmotos" : preload("res://assets/scenes/secrets/motos_parent.tscn"),
	"goodending" : preload("res://assets/scenes/ending_cutscene.tscn")
}

var scene_ID := ""
var current_scene = null

func _ready():
	for world in range(WORLD_LENGTHS.size()):
		for level in range(1, WORLD_LENGTHS[world] + 1):
			var SCENE_NAME = "res://assets/scenes/stages/stage_" + str(world) + "_" + str(level) + ".tscn"
			scenes["stage" + str(world) + "-" + str(level)] = load(SCENE_NAME)
	
	$PauseMenu.visible = false
	change_scene("disclaimer", 0)
	$HUD/Thoughts.play("Static")

func _process(delta: float) -> void:
	if global_time:
		total_time_elapsed += delta
	$HUD/TimeLabel.text = "Total Time: " + _format_seconds(total_time_elapsed)

func _format_seconds(time : float) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	return "%02d:%02d" % [minutes, seconds]

func _physics_process(delta):
	#if Input.is_action_just_pressed("Fullscreen"):
		#options.settings_fullscreen = !options.settings_fullscreen
		#if options.settings_fullscreen:
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			##DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		#else:
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			##DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass
	

func change_scene(next_scene : String, reset_or_skip: int):
	# on scene exit
	if current_scene == null:
		pass
	else:
		match scene_ID:
			"title", "options", "goodending", "onto1", "onto2", "onto3", "onto4", "secretbart", "secretmotos":
				pass
			_:
				match reset_or_skip:
					1:
						total_resets += 1
						$HUD/SingleplayerLabels/ResetLabel.text = "Resets: " + str(total_resets)
						if $HUD/Thoughts.animation == "Backrooms1":
							$HUD/Thoughts.play("Static")
					2:
						total_skips += 1
						$HUD/SingleplayerLabels/SkipsLabel.text = "Skips: " + str(total_skips)
						$Sounds/sfxSkip.play()
					3:
						pass
					_:
						total_score += (current_scene.finalbonus)
						$HUD/SingleplayerLabels/ScoreLabel.text = "Score: " + str(total_score)
	
	if current_scene:
		current_scene.queue_free()
	scene_ID = next_scene
	var newScene = scenes[scene_ID].instantiate()
	current_scene = newScene
	await get_tree().process_frame
	add_child(newScene)
	
	newScene.progress.connect(change_scene)
	
	match scene_ID:
		"disclaimer", "onto1", "onto2", "onto3", "onto4", "secretbart", "secretmotos":
			change_music("nothing")
		"title":
			reset_game()
			change_music("bgmTitle")
			newScene.selected.connect(change_music)
		"options":
			change_music("bgmOptions")
			newScene.get_node("SettingsStuff/SoundSlider").value_changed.connect(change_volumes)
			newScene.get_node("SettingsStuff/MusicSlider").value_changed.connect(change_volumes)
			for i in newScene.get_node("ModifierStuff").get_children():
				i.toggled.connect(modifier_hud)
		"goodending":
			global_time = false
			change_music("bgmCredits")
		_:
			change_music(newScene.music_choice)
			global_time = true
			newScene.gamepause.connect(pause_game)
			newScene.tv_queue_add.connect(add_to_queue)
			newScene.backrooms.connect(change_music)

func change_music(song : String):
	var song_node = get_node("Music/" + song)
	if song_node.playing:
		return
	for node in $Music.get_children():
		node.stop()
	song_node.play()

func reset_game():
	total_score = 0
	$HUD/SingleplayerLabels/ScoreLabel.text = "Score: " + str(total_score)
	total_resets = 0
	$HUD/SingleplayerLabels/ResetLabel.text = "Resets: " + str(total_resets)
	total_skips = 0
	$HUD/SingleplayerLabels/SkipsLabel.text = "Skips: " + str(total_skips)
	global_time = false
	total_time_elapsed = 0.0

func pause_game():
	get_tree().set_deferred("paused", true)
	global_time = false
	$Sounds/sfxPause.play()
	$PauseMenu/AnimatedSprite2D.play()
	$PauseMenu.visible = true
	for node in $Music.get_children():
		node.pitch_scale = 0.75

func _on_resume_button_pressed():
	get_tree().set_deferred("paused", false)
	global_time = true
	$Sounds/sfxPause.stop()
	$PauseMenu/AnimatedSprite2D.stop()
	$PauseMenu.visible = false
	for node in $Music.get_children():
		node.pitch_scale = 1.0

func _on_menu_button_pressed():
	get_tree().paused = false
	$Sounds/sfxPause.stop()
	$PauseMenu/AnimatedSprite2D.stop()
	$PauseMenu.visible = false
	change_scene("title", 3)
	for node in $Music.get_children():
		node.pitch_scale = 1.0

func add_to_queue(animaname):
	thoughts_queue = animaname
	if ((thoughts_queue == "Money" and $HUD/Thoughts.animation.contains("Money")) or (thoughts_queue == "Skull" and $HUD/Thoughts.animation.contains("Skull")) or (thoughts_queue == "Chuckle" and $HUD/Thoughts.animation.contains("Chuckle")) or (thoughts_queue == "Car" and $HUD/Thoughts.animation.contains("Car"))):
		thoughts_queue = ""
	else:
		$HUD/Thoughts.play("Static")

func _on_thoughts_animation_finished():
	if $HUD/Thoughts.animation == "Static":
		match thoughts_queue:
			"Backrooms":
				var randopick = randi_range(1, 1)
				$HUD/Thoughts.play("Backrooms" + str(randopick))
				thoughts_queue = ""
			"Dog":
				var randopick = randi_range(1, 1)
				$HUD/Thoughts.play("Dog" + str(randopick))
				thoughts_queue = ""
			"Car":
				var randopick = randi_range(1, 1)
				$HUD/Thoughts.play("Car" + str(randopick))
				thoughts_queue = ""
			"Skull":
				var randopick = randi_range(1, 3)
				$HUD/Thoughts.play("Skull" + str(randopick))
				thoughts_queue = ""
			"Chuckle":
				var randopick = randi_range(1, 3)
				$HUD/Thoughts.play("Chuckle" + str(randopick))
				thoughts_queue = ""
			"Money":
				var randopick = randi_range(1, 2)
				$HUD/Thoughts.play("Money" + str(randopick))
				thoughts_queue = ""
			"Move":
				var randopick = randi_range(1, 8)
				$HUD/Thoughts.play("Move" + str(randopick))
				thoughts_queue = ""
			"Win":
				var randopick = randi_range(1, 9)
				$HUD/Thoughts.play("Win" + str(randopick))
				thoughts_queue = ""
			"Death":
				var randopick = randi_range(1, 14)
				$HUD/Thoughts.play("Death" + str(randopick))
				thoughts_queue = ""
			_:
				if global_time:
					var randopick = randi_range(1, 13)
					$HUD/Thoughts.play("Idle" + str(randopick))
				else:
					$HUD/Thoughts.play("Static")
	elif $HUD/Thoughts.animation == "Backrooms1":
		$HUD/Thoughts.play("Backrooms1")
	else:
		$HUD/Thoughts.play("Static")
	

func change_volumes(placeholder):
	for i in $Music.get_children():
		if options.settings_music_volume == 0:
			i.volume_db = -80
		else:
			i.volume_db = -40 + (2 * options.settings_music_volume)
	for i in $Sounds.get_children():
		if options.settings_sound_volume == 0:
			i.volume_db = -80
		else:
			i.volume_db = -40 + (2 * options.settings_sound_volume)

func modifier_hud(placeholder):
	$HUD/ModifierGFX/HardModeGraphic.visible = options.modifier_hardmode
	
	$HUD/Thinker.texture = load("res://assets/graphics/uncanny.png") if (options.modifier_roleswap) else load("res://assets/graphics/canny.png")
	
	get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT if (options.modifier_hypercam) else Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	$HUD/ModifierGFX/HypercamGraphic.visible = options.modifier_hypercam
	
