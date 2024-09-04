extends Node2D

signal motos_progress

var enemies_left := 0
var meteor_active := false
@export var meteor_countdown := 1200

func _ready():
	for i in $Grid.get_used_cells(0):
		var floor_tile = load("res://assets/scenes/secrets/objects/motos_floor.tscn").instantiate()
		floor_tile.global_position = Vector2(i.x * 32 + 16, i.y * 32 + 16)
		$Floor.add_child(floor_tile)
	
	$MotosPlayer.died.connect(player_died)
	for i in $Enemies.get_children():
		i.target = $MotosPlayer
		i.died.connect(enemy_died)
		enemies_left += 1
	$Sounds/sfxStart.play()
	await get_tree().create_timer(2.0).timeout
	$MotosPlayer.playmode = true
	for i in $Enemies.get_children():
		i.playmode = true
	meteor_active = true
	$Sounds/musTheme.play()
	while enemies_left > 0:
		await get_tree().create_timer(0.01).timeout
	$Sounds/musTheme.stop()
	$Sounds/sfxClear.play()

func _physics_process(delta):
	if meteor_active and meteor_countdown < 0:
		spawn_meteor()
		meteor_countdown = 120
	elif meteor_active:
		meteor_countdown -= 1

func _on_sfx_clear_finished():
	motos_progress.emit("mStage1", false)

func enemy_died(value):
	get_parent().score += value
	enemies_left -= 1

func player_died(value):
	if $Sounds/sfxClear.playing:
		pass
	elif get_parent().lives > 0:
		motos_progress.emit("mStage1", true)
	else:
		motos_progress.emit("mGameOver", true)

func spawn_meteor():
	#var scene_collection = $Grid.tile_set.get_source(0)
	#if scene_collection is TileSetScenesCollectionSource:
		#for i in scene_collection.get_scene_tiles_count():
			#var id = scene_collection.get_scene_tile_id(i)
			#var scene = scene_collection.get_scene_tile_scene(id)
			#scene.pitfall()
	var all_floors = $Floor.get_children()
	var chosen_floor = all_floors[randi()% all_floors.size()]
	chosen_floor.pitfall()
