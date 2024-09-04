extends Stage

var car := preload("res://assets/scenes/objects/baddie_car_spawner.tscn")

func _ready():
	super._ready()
	$GlowstickLightRotater.visible = false

func _process(delta : float):
	super._process(delta)

func _physics_process(delta : float):
	super._physics_process(delta)

func _on_police_trigger_body_entered(body):
	$GlowstickLightRotater.visible = true
	
	var cc = car.instantiate()
	cc.spawn_rate = 45
	cc.car_speed = 170
	cc.car_direction = Vector2(1, 0)
	cc.car_rotate = 0
	cc.car_color = Color(255.0/255.0, 158/255.0, 247/255.0, 1)
	cc.position = Vector2(192, 432)
	$CollectibleObjects.add_child(cc)
	
	$sfxSiren.play()
	$PoliceTrigger.queue_free()
