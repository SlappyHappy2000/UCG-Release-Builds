extends Control

@export var options : Options

var world_ID := "0"
var level_ID := "1"

var selected_stage := "stage0-1"
var bg_uncanny := preload("res://assets/graphics/uncanny.png")

var splash = [
	"honestly quite incredible",
	"golf for life",
	"rofl",
	"SPLASH TEXT PLACEHOLDER"
]

signal progress
signal selected

func _ready():
	for i in $Sounds.get_children():
		if options.settings_sound_volume == 0:
			i.volume_db = -80
		else:
			i.volume_db = -40 + (2 * options.settings_sound_volume)
	
	#var buttonadd = Button.new()
	#for world in range(get_parent().WORLD_LENGTHS.size()):
		#buttonadd.text = str(world)
		#buttonadd.pressed.connect(world_button_select)
		#add_child(buttonadd)
	
	RenderingServer.set_default_clear_color(Color(0, 136.0/255.0, 237.0/255.0, 1))
	$UncannyCats.visible = false
	$CannyCats.visible = true
	$PanicMode.visible = false
	$SplashLabel.text = splash.pick_random()
	$LevelSelect.visible = false

func _process(delta):
	$ParallaxBackground.scroll_offset.y += (30 * delta)

func _physics_process(delta):
	if Input.is_action_just_pressed("PanicModeActivate"):
		progress.emit("secretbart", 3)
	if Input.is_action_just_pressed("MotosJump"):
		progress.emit("secretmotos", 3)

func _on_start_button_pressed():
	selected.emit("nothing")
	$Sounds/sfxSelected.play()
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1))
	$UncannyCats.visible = !$UncannyCats.visible
	$CannyCats.visible = !$CannyCats.visible
	for i in $VBoxContainer.get_children():
		i.visible = false
	for i in $ParallaxBackground/ParallaxLayer.get_children():
		i.texture = bg_uncanny
	await get_tree().create_timer(1.5).timeout
	progress.emit(selected_stage, 0)

func _on_quit_button_pressed():
	get_tree().quit()

func _on_level_button_pressed():
	$Title.visible = false
	$SplashLabel.visible = false
	$CannyCats.visible = false
	for i in $VBoxContainer.get_children():
		i.visible = false
	
	$LevelSelect.visible = true
	$LevelSelect/ChoiceDisplay.text = world_ID + "-" + level_ID

func world_button_select():
	for b in $LevelSelect/World.get_children():
		if b.button_pressed:
			world_ID = b.text
			break
	
	$LevelSelect/ChoiceDisplay.text = world_ID + "-" + level_ID

func level_button_select():
	for b in $LevelSelect/Level.get_children():
		if b.button_pressed:
			level_ID = b.text
			break
	
	$LevelSelect/ChoiceDisplay.text = world_ID + "-" + level_ID

func _on_confirm_pressed():
	#bad code alert! bad code alert! but the numbers are strings, so i can't use operators... fix this later
	if world_ID == "0" and level_ID != "1" and level_ID != "2" and level_ID != "3" and level_ID != "4" and level_ID != "5":
		$Sounds/sfxNo.play()
	else:
		$Title.visible = true
		$SplashLabel.visible = true
		$CannyCats.visible = true
		for i in $VBoxContainer.get_children():
			i.visible = true
		
		$LevelSelect.visible = false
		
		selected_stage = "stage" + world_ID + "-" + level_ID
		_on_start_button_pressed()

func _on_options_button_pressed():
	for i in $VBoxContainer.get_children():
		i.visible = false
	$Sounds/sfxOption.play()
	await get_tree().create_timer(1.0).timeout
	progress.emit("options", 0)
