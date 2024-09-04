extends Node2D

signal progress

var game_active := false
var winmode := false

var round := 0
var score := 0
var bart_spawn_number := 0
var barts_left := 0

var timer := 30

func _ready():
	$GameOver.visible = false
	$HUD/Score.text = "Score: " + str(score)
	while !game_active:
		if Input.is_action_just_pressed("Click"):
			game_active = true
		await get_tree().create_timer(0.01).timeout
	$clickallbarts.visible = false
	$Music/midiChuckle.play()
	$HUD/Timer.text = str(timer)
	next_round()
	while timer > 0:
		await get_tree().create_timer(1.0).timeout
		if !winmode:
			timer -= 1
	game_active = false
	time_over()

func _physics_process(delta):
	$HUD/Timer.text = str(timer)
	if Input.is_action_just_pressed("Pause"):
		progress.emit("title", 0)

func next_round():
	if !game_active:
		return
	round += 1
	$HUD/Round.text = "ROUND " + str(round)
	bart_spawn_number = round * 5
	for i in range(0, bart_spawn_number):
		var newBart = load("res://assets/scenes/secrets/objects/bart.tscn").instantiate()
		var speed = randi_range(100 + round * 30, 600 + round * 30)
		newBart.velocity = speed * (Vector2.from_angle(randf_range(0.261, 1.309) + randi_range(0, 3) * PI * 0.5))
		newBart.global_position = Vector2(randi_range(320, 704), randi_range(128, 448))
		newBart.die.connect(bart_kill)
		$Objects.add_child(newBart)
		barts_left += 1
	timer = 30
	$HUD/BartsLeft.text = "Barts Left: " + str(barts_left)

func bart_kill():
	barts_left -= 1
	$HUD/BartsLeft.text = "Barts Left: " + str(barts_left)
	score += 50
	$HUD/Score.text = "Score: " + str(score)
	if barts_left == 0:
		winmode = true
		$Sounds/sfxCongrats.play()
		await get_tree().create_timer(2).timeout
		next_round()
		winmode = false

func time_over():
	for i in $Objects.get_children():
		i.queue_free()
	$GameOver.visible = true
