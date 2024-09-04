extends Control

@export var options : Options
signal progress

var color_change := 0.0

func _ready():
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1))
	
	$ModifierStuff/easymode.button_pressed = options.modifier_easymode
	$ModifierStuff/hardmode.button_pressed = options.modifier_hardmode
	$ModifierStuff/roleswap.button_pressed = options.modifier_roleswap
	$ModifierStuff/burst.button_pressed = options.modifier_burst
	$ModifierStuff/telekinetic.button_pressed = options.modifier_telekinetic
	$ModifierStuff/glass.button_pressed = options.modifier_glass
	$ModifierStuff/hypercam.button_pressed = options.modifier_hypercam
	
	$SettingsStuff/FullscreenSwitch.button_pressed = options.settings_fullscreen
	$SettingsStuff/FullscreenSwitch.toggled.connect(_on_fullscreen_switch_toggled)
	
	$SettingsStuff/SoundSlider.value = options.settings_sound_volume
	$AstheticalStuff/SoundVolumeText.text = "Sound Volume: " + str($SettingsStuff/SoundSlider.value * 5) + "%"
	$SettingsStuff/SoundSlider.value_changed.connect(_on_sound_slider_value_changed)
	
	$SettingsStuff/MusicSlider.value = options.settings_music_volume
	$AstheticalStuff/MusicVolumeText.text = "Music Volume: " + str($SettingsStuff/MusicSlider.value * 5) + "%"
	$SettingsStuff/MusicSlider.value_changed.connect(_on_music_slider_value_changed)
	
	$BackButton.mouse_entered.connect(hover_description.bind($BackButton))
	for i in $AstheticalStuff.get_children():
		i.mouse_entered.connect(hover_description.bind(i))
	for i in $SettingsStuff.get_children():
		i.mouse_entered.connect(hover_description.bind(i))
	for i in $ModifierStuff.get_children():
		i.mouse_entered.connect(hover_description.bind(i))

func _physics_process(delta):
	color_change += 1/360.0
	if color_change > 1.0:
		color_change = 0/360.0
	$OptionsBG.modulate = Color.from_hsv(color_change, 0.5, 0.25, 1)

func _on_back_button_pressed():
	progress.emit("title", 0)

func _on_fullscreen_switch_toggled(toggled_on):
	options.settings_fullscreen = toggled_on
	if options.settings_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_sound_slider_value_changed(value):
	if !options.modifier_hypercam:
		options.settings_sound_volume = value
	$AstheticalStuff/SoundVolumeText.text = "Sound Volume: " + str(value * 5) + "%"

func _on_music_slider_value_changed(value):
	if !options.modifier_hypercam:
		options.settings_music_volume = value
	$AstheticalStuff/MusicVolumeText.text = "Music Volume: " + str(value * 5) + "%"

func modifier_select(toggle : bool, mod : String):
	options.set(mod, toggle)

func hover_description(i):
	match i.name:
		"BackButton":
			$OptionDescription.text = "Done here? Return to the title screen."
		"FakeOptionsTitle":
			$OptionDescription.text = "Yes, this is the options menu. Hello."
		"Settings":
			$OptionDescription.text = "Adjust the settings to your liking."
		"FullscreenSwitch":
			$OptionDescription.text = "Toggle fullscreen."
		"SoundSlider", "SoundVolumeText":
			$OptionDescription.text = "Adjust the volume of sound effects in the game."
		"MusicSlider", "MusicVolumeText":
			$OptionDescription.text = "Adjust the volume of music in the game."
		"Modifiers":
			$OptionDescription.text = "Modifiers change up the game to make your next playthrough more interesting. Each modifier changes something different about how the game plays; modifiers can be mixed and matched together for fun combinations. Be wary that not all modifier combinations may be tested properly together."
		"easymode":
			$OptionDescription.text = "Stress-Free: All uncanny cats get removed. Enjoy the simples of plain' ol golf without the thrill of being chased."
		"hardmode":
			$OptionDescription.text = "Hard Mode: All uncanny cats get an uncanny upgrade in both appearance and speed. They are not messing around."
		"roleswap":
			$OptionDescription.text = "Switcheroo: The roles are reversed! You play as the uncanny and the canny chases you, with a surprise or two sprinkled in."
		"burst":
			$OptionDescription.text = "Burst: You don't have to come to a standstill to hit the cat. Designed for a speedier playthrough."
		"telekinetic":
			$OptionDescription.text = "Telekinetic: Don't click to physically hit the cat! Your mouse moving speed determines your cat speed."
		"glass":
			$OptionDescription.text = "Fabergé Cat: Your cat is delicate and fragile. Three hits against the wall and you shatter!"
		"hypercam":
			$OptionDescription.text = "Unregistered Hypercat 2: Do NOT turn on under any circumstances. You are not prepared to handle such epicness."
		_:
			$OptionDescription.text = ""

