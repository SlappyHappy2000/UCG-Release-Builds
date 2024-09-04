extends Node2D

signal progress

@onready var paint := $TileMap
var brush_color := 0

func _physics_process(delta):
	# Input check to change colors
	if brush_color > 0 and Input.is_action_just_pressed("left2"):
		$HudColors.frame -= 1
		brush_color = $HudColors.frame
	if brush_color < ($HudColors.hframes - 1) and Input.is_action_just_pressed("right2"):
		$HudColors.frame += 1
		brush_color = $HudColors.frame
	
	# Input check to change canvas
	if $Canvas.frame > 0 and Input.is_action_just_pressed("left3"):
		$Canvas.frame -= 1
		$HudCanvas.frame = $Canvas.frame
	if $Canvas.frame < ($Canvas.hframes - 1) and Input.is_action_just_pressed("right3"):
		$Canvas.frame += 1
		$HudCanvas.frame = $Canvas.frame
	
	# Left click to paint tiles
	if Input.is_action_pressed("Click"):
		var tile : Vector2 = paint.local_to_map(get_global_mouse_position())
		paint.set_cell(0, tile, 0, Vector2(brush_color, 0))
	# Right click to erase tiles
	if Input.is_action_pressed("RightClick"):
		var tile : Vector2 = paint.local_to_map(get_global_mouse_position())
		paint.set_cell(0, tile, -1, Vector2(brush_color, 0))
	# Button to completely clear tiles
	if Input.is_action_just_pressed("PanicModeActivate"):
		paint.clear()
	
	
	# You know what this is...
	if Input.is_action_just_pressed("Pause"):
		progress.emit("title", 0)
