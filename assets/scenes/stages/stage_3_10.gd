extends Stage

func _ready():
	super._ready()
	$jumpscaresprite.visible = false
	while !level_game_active:
		await get_tree().create_timer(0.1).timeout
	$Tiles1.material.set_shader_parameter("C1", Plane(0, 0, 0, 1))
	$Tiles1.material.set_shader_parameter("C2", Plane(0, 0, 0, 1))
	$Tiles1.material.set_shader_parameter("C3", Plane(0, 0, 0, 1))
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1))
	$MainObjects/CatGolf.modulate = Color(153.0/255.0, 153.0/255.0, 153.0/255.0, 1)
	$MainObjects/GoalHole.modulate = Color(153.0/255.0, 153.0/255.0, 153.0/255.0, 1)
	for i in $MainObjects/UncannyCats.get_children():
		i.modulate = Color(153.0/255.0, 153.0/255.0, 153.0/255.0, 1)

func _process(delta : float):
	super._process(delta)

func _physics_process(delta : float):
	super._physics_process(delta)

func win_process():
	$jumpscaresprite.visible = true
	$sfxJumpscare.play()
	super.win_process()
	while $jumpscaresprite.modulate.a8 > 0:
		$jumpscaresprite.modulate.a8 -= 2
		await get_tree().create_timer(0.01).timeout
