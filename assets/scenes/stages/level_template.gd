extends Node2D
class_name Stage

@export var options : Options

signal progress
signal gamepause
signal tv_queue_add
signal backrooms
signal switched

var just_clicked := false

var restart_game_active := false
var level_game_active := false
var skipcounter := 0

@export var level_name : String
@export var scene_ID : String
@export var music_choice : String
@export var stage_color : Color
@export var progress_destination : String
@export var peak_value : int

var golfhit := 0
var total_time_elapsed := 0.0

var golfhitbonus := 0
var timebonus := 0
var collectiblebonus := 0

var finalbonus := 0

func _ready():
	options = load("res://assets/default_options.tres")
	
	for i in $Sounds.get_children():
		if options.settings_sound_volume == 0:
			i.volume_db = -80
		else:
			i.volume_db = -40 + (2 * options.settings_sound_volume)
	
	if options.modifier_hardmode and options.modifier_roleswap:
		get_node("UncannyDeath/deathsprite").texture = load("res://assets/graphics/ultracanny.png")
		$Sounds/sfxUncannyDeath.stream = load("res://assets/sounds/sfxSlideWhistle.ogg")
	elif options.modifier_hardmode:
		get_node("UncannyDeath/deathsprite").texture = load("res://assets/graphics/ultrauncanny.png")
	elif options.modifier_roleswap:
		get_node("UncannyDeath/deathsprite").texture = load("res://assets/graphics/canny.png")
		$Sounds/sfxUncannyDeath.stream = load("res://assets/sounds/sfxSlideWhistle.ogg")
	
	RenderingServer.set_default_clear_color(stage_color)
	$HUD/StageNameLabel.text = level_name
	
	$SwitchTiles1.visible = true
	$SwitchTiles1.tile_set.set_physics_layer_collision_layer(0, 1)
	$SwitchTiles2.visible = false
	$SwitchTiles2.tile_set.set_physics_layer_collision_layer(0, 0)
	$DogTiles.visible = true
	$DogTiles.tile_set.set_physics_layer_collision_layer(0, 1)
	
	$UncannyDeath.visible = false
	for i in $MainObjects/UncannyCats.get_children():
		i.target = $MainObjects/CatGolf
		i.caught.connect(death)
	
	for i in $MainObjects/MultiplayerCats.get_children():
		i.caught.connect(death)
	
	for i in $CollectibleObjects.get_children():
		if i.name.contains("BaddieChuckle"):
			i.target = $MainObjects/CatGolf
	
	$StageResults/GolfHitR.visible = false
	$StageResults/TimeTakenR.visible = false
	$StageResults/CollectibleBonusR.visible = false
	$StageResults/FinalScoreR.visible = false
	$StageResults/RankTextR.visible = false
	$StageResults/Rank.visible = false
	$WinConfetti.visible = false
	$ClickMark.visible = false
	
	$MainObjects/CatGolf.spawned.connect(start_process)
	$MainObjects/CatGolf.hit_up.connect(hit_add)
	$MainObjects/GoalHole.win.connect(win_process)
	for c in $CollectibleObjects.get_children():
		c.collected.connect(obj_collision_sfx)
	
	$HUD/StageNameLabel/AnimationPlayer.play("stagenameslide")
	
	#TV Connection
	$MainObjects/CatGolf.tv_p.connect(send_tv_queue)

# Timer Stuff
func _process(delta: float) -> void:
	if level_game_active:
		total_time_elapsed += delta
		$HUD/LevelTimeLabel.text = "Time: " + _format_seconds(total_time_elapsed)

func _format_seconds(time : float) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	return "%02d:%02d" % [minutes, seconds]

func _physics_process(delta):
	if level_game_active and Input.is_action_just_pressed("Pause"):
		gamepause.emit()
	
	if level_game_active and (($MainObjects/CatGolf.position.x >= 792) or ($MainObjects/CatGolf.position.x <= 232) or ($MainObjects/CatGolf.position.y >= 536) or ($MainObjects/CatGolf.position.y <= -24)):
		death("outofbounds")
	
	if Input.is_action_just_pressed("Click"):
		just_clicked = true
		$ClickMark.visible = true
		$ClickMark.global_position = get_global_mouse_position()
	if Input.is_action_just_released("Click"):
		$ClickMark.visible = false
	
	if restart_game_active and Input.is_action_just_pressed("Restart"):
		progress.emit(scene_ID, 1)
	
	if level_game_active and Input.is_action_pressed("Skip"):
		skipcounter += 1
		if skipcounter > 30:
			progress.emit(progress_destination, 2)
	else:
		skipcounter = 0
	

func start_process():
	restart_game_active = true
	level_game_active = true

func win_process():
	for i in $MainObjects/UncannyCats.get_children():
		i.queue_free()
	for i in $MainObjects/MultiplayerCats.get_children():
		i.queue_free()
	for j in $CollectibleObjects.get_children():
		if j.name.contains("ChuckleSpawner"):
			j.queue_free()
	$MainObjects/CatGolf.transition_to("CGWin")
	$WinConfetti.visible = true
	$WinConfetti.play()
	level_game_active = false
	send_tv_queue("Win")
	results_move([0.05], [0.0], 0.01)

func hit_add():
	golfhit += 1
	$HUD/GolfHitLabel.text = "Strokes: " + str(golfhit)

func obj_collision_sfx(value : int, soundeff : String):
	collectiblebonus += value
	match soundeff:
		"Nuke":
			for i in $CollectibleObjects.get_children():
				if i is BaddieChuckle:
					i.queue_free()
		"DogSwitch":
			send_tv_queue("Dog")
			$DogTiles.visible = false
			$DogTiles.tile_set.set_physics_layer_collision_layer(0, 0)
		"Switch":
			for i in $CollectibleObjects.get_children():
				if i.name.contains("SwitchBlock"):
					i.get_node("Sprite2D").frame = (1 - i.get_node("Sprite2D").frame)
			$SwitchTiles1.visible = !$SwitchTiles1.visible
			$SwitchTiles1.tile_set.set_physics_layer_collision_layer(0, $SwitchTiles1.visible)
			$SwitchTiles2.visible = !$SwitchTiles2.visible
			$SwitchTiles2.tile_set.set_physics_layer_collision_layer(0, $SwitchTiles2.visible)
			$Sounds/sfxSwitch.pitch_scale = randf_range(0.8, 1.2)
			switched.emit()
		"DBaddie":
			send_tv_queue("Skull")
			$Sounds/sfxDBaddie.pitch_scale = randf_range(0.8, 1.55)
		"DChuckle":
			send_tv_queue("Chuckle")
			$Sounds/sfxDChuckle.pitch_scale = randf_range(0.7, 1.3)
		"DCar":
			send_tv_queue("Car")
			if randi_range(1, 5) == 5:
				var hornpick = randi_range(1, 2)
				$Sounds.get_node("sfxDHorn" + str(hornpick)).pitch_scale = randf_range(0.8, 1.2)
				$Sounds.get_node("sfxDHorn" + str(hornpick)).play()
		"Coin":
			send_tv_queue("Money")
		_:
			pass
	get_node("Sounds/sfx" + soundeff).play()

func results_move(speed : Array, height : Array, delay : float):
	await get_tree().create_timer(0.7).timeout
	for i in range(speed.size()):
		while (abs(height[i] - $StageResults.position.y) > 1):
			$StageResults.position.y = lerp($StageResults.position.y, height[i], speed[i])
			await get_tree().create_timer(delay).timeout
	$StageResults.position.y = height.back()
	calculate_score()
	results_appear()
	just_clicked = false
	while !just_clicked:
		await get_tree().create_timer(0.1).timeout
	just_clicked = false
	await get_tree().create_timer(0.1).timeout
	progress.emit(progress_destination, 0)

#this is bad code but i don't give a swag for now lmfaoooo
func results_appear():
	if golfhit > 1:
		$StageResults/GolfHitR.text = "Golf Hit Bonus: " + str(golfhitbonus)
	else:
		$StageResults/GolfHitR.modulate = Color(0, 1, 0, 1)
		$StageResults/GolfHitR.text = "HOLE IN " + ("NONE" if (golfhit ==  0) else "ONE") + "! Bonus:" + str(golfhitbonus)
	
	$StageResults/GolfHitR.visible = true
	$Sounds/sfxResultsBang.play()
	await get_tree().create_timer(0.3).timeout
	
	$StageResults/TimeTakenR.text = "Time Bonus: " + str(timebonus)
	$StageResults/TimeTakenR.visible = true
	$Sounds/sfxResultsBang.play()
	await get_tree().create_timer(0.3).timeout
	
	$StageResults/CollectibleBonusR.text = "Collectible Bonus: " + str(collectiblebonus)
	$StageResults/CollectibleBonusR.visible = true
	$Sounds/sfxResultsBang.play()
	await get_tree().create_timer(0.3).timeout
	
	$StageResults/FinalScoreR.text = "Final Stage Score: " + str(finalbonus)
	$StageResults/FinalScoreR.visible = true
	$Sounds/sfxResultsBang.play()
	await get_tree().create_timer(0.3).timeout
	
	$StageResults/RankTextR.visible = true
	$Sounds/sfxResultsBang.play()
	await get_tree().create_timer(0.4).timeout
	
	rank_play()

func calculate_score():
	#Golf Bonus
	match golfhit:
		0, 1:
			golfhitbonus = 10000
		_:
			#use clamp function
			golfhitbonus = 6000 - 500 * golfhit
			if golfhitbonus < 0 or golfhitbonus > 5000:
				golfhitbonus = 0
	#Time Bonus
	var seconds = floor(total_time_elapsed)
	timebonus = 6000 - 100 * (seconds)
	if timebonus < 0:
		timebonus = 0
	#Collectible Bonus is automatically gotten when you collect coins and stuff
	
	#BonusCalculate
	finalbonus = golfhitbonus + timebonus + collectiblebonus

# Array filled with rank names in descending order
var rankings : Array[String] = [
	"RankPeak", 
	"RankSwag",
	"RankOK",
	"RankBelowAverage",
	"RankAwful",
	"RankUncanny",
	"NoRank"
]

func rank_play():
	if finalbonus <= 0:
		$StageResults/Rank/AnimationPlayer.play("RankUncanny")
		$Sounds/sfxRankUncanny.play()
	else:
		var rank_number := clampi(8 - floor(8.0 * finalbonus / peak_value), 0, 4)
		$StageResults/Rank/AnimationPlayer.play(rankings[rank_number])
		get_node("Sounds/sfx" + rankings[rank_number]).play()
	await get_tree().create_timer(0.01).timeout
	$StageResults/Rank.visible = true

func death(placeholder : String):
	level_game_active = false
	for i in $CollectibleObjects.get_children():
		i.queue_free()
	for i in $MainObjects/UncannyCats.get_children():
		i.queue_free()
	for i in $MainObjects/MultiplayerCats.get_children():
		i.queue_free()
	$MainObjects/CatGolf.queue_free()
	
	if placeholder == "outofbounds":
		$UncannyDeath/deathsprite.texture = load("res://assets/graphics/backrooms.png")
		backrooms.emit("nothing")
		$UncannyDeath.visible = true
		send_tv_queue("Backrooms")
	elif placeholder == "glass":
		$UncannyDeath2.visible = true
		$UncannyDeath2/deathsprite.play()
		$Sounds/sfxUncannyDeath.play()
		send_tv_queue("Death")
	else:
		$UncannyDeath.visible = true
		$Sounds/sfxUncannyDeath.play()
		send_tv_queue("Death")
	
	just_clicked = false
	while !just_clicked:
		await get_tree().create_timer(0.1).timeout
	just_clicked = false
	progress.emit(scene_ID, 1)

func send_tv_queue(tvname : String):
	tv_queue_add.emit(tvname)
