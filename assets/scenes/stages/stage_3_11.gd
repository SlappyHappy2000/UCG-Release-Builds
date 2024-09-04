extends Stage

func _ready():
	super._ready()
	$MainObjects/DogGoal.doghouse.connect(dog_goal_process)

func _process(delta : float):
	super._process(delta)

func _physics_process(delta : float):
	super._physics_process(delta)

func dog_goal_process():
	$MainObjects/DogGolf.set_collision_layer_value(1, false)
	$MainObjects/DogGolf.winner = true
	obj_collision_sfx(500, "DogSwitch")
