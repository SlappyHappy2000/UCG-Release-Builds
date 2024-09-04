extends Stage

var big_switch := 0
var switch_tiles : Array

func _ready():
	super._ready()
	$SwitchTiles3.visible = false
	$SwitchTiles3.tile_set.set_physics_layer_collision_layer(0, 0)
	$SwitchTiles4.visible = false
	$SwitchTiles4.tile_set.set_physics_layer_collision_layer(0, 0)
	switch_tiles = [
		$SwitchTiles1,
		$SwitchTiles2,
		$SwitchTiles3,
		$SwitchTiles4
	]

func _process(delta : float):
	super._process(delta)

func _physics_process(delta : float):
	super._physics_process(delta)

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
			switch_tiles[big_switch].visible = false
			switch_tiles[big_switch].tile_set.set_physics_layer_collision_layer(0, 0)
			big_switch = (big_switch + 1) % switch_tiles.size()
			for i in $CollectibleObjects.get_children():
				if i.name.contains("SwitchBlock"):
					i.get_node("Sprite2D").frame = big_switch
			switch_tiles[big_switch].visible = true
			switch_tiles[big_switch].tile_set.set_physics_layer_collision_layer(0, 1)
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
