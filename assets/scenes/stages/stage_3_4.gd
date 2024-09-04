extends Stage

func _ready():
	super._ready()
	switched.connect(switch_bg)
	RenderingServer.set_default_clear_color(Color(93.0/255.0, 133.0/255.0, 109.0/255.0, 1))

func _process(delta : float):
	super._process(delta)

func _physics_process(delta : float):
	super._physics_process(delta)

func switch_bg():
	if $SwitchTiles1.visible:
		RenderingServer.set_default_clear_color(Color(93.0/255.0, 133.0/255.0, 109.0/255.0, 1))
	else:
		RenderingServer.set_default_clear_color(Color(133.0/255.0, 86.0/255.0, 86.0/255.0, 1))
