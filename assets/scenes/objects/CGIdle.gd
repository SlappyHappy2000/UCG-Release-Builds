extends State

var clickpos := Vector2.ZERO
var hit_dir = null

func enter(type : int = 0):
	hit_dir = owner.get_node("HitDirection")
	owner.get_node("Sounds").get_node("sfxPickUpNotif").play()
	hit_dir.visible = false
	if Input.is_action_pressed("Click"):
		clickpos = owner.owner.get_node("ClickMark").position
		owner.get_node("Sounds").get_node("sfxGrab").play()

func exit():
	pass

func update():
	if Input.is_action_just_pressed("Click"):
		clickpos = owner.owner.get_global_mouse_position()
		owner.get_node("Sounds").get_node("sfxGrab").play()
		
	if Input.is_action_pressed("Click"):
		hit_dir.visible = true
		hit_dir.points[1] = (clickpos - owner.owner.get_global_mouse_position()).limit_length(owner.MAX_DRAG)
		if (hit_dir.points[1] - hit_dir.points[0]).length() < owner.DRAG_CANCEL:
			hit_dir.default_color = Color.from_hsv(0, 1, 0.5, 1)
		else:
			var hue = ((hit_dir.points[1] - hit_dir.points[0]).length() - owner.DRAG_CANCEL) / (owner.MAX_DRAG - owner.DRAG_CANCEL)
			hit_dir.default_color = Color.from_hsv(lerpf(owner.HUE_WEAKEST, owner.HUE_STRONGEST, hue), 0.68, 1, 0.5)
		
	if Input.is_action_just_released("Click"):
		hit_dir.visible = false
		owner.velocity = owner.DRAG_MULTIPLIER * (hit_dir.points[1] - hit_dir.points[0])
		if owner.velocity.length() < owner.DRAG_CANCEL * owner.DRAG_MULTIPLIER:
			owner.velocity = Vector2.ZERO
			owner.get_node("Sounds").get_node("sfxGrabCancel").play()
			return
		owner.hit_up.emit()
		if owner.velocity.length() > 500:
			owner.tv_p.emit("Move")
		owner.transition_to("CGMoving")
		return

