extends State

var mouse_pos := Vector2.ZERO
var previous_mouse_pos := Vector2.ZERO

func enter(type : int = 0):
	Input.warp_mouse(Vector2((get_viewport().size.x / 2), (get_viewport().size.y / 2)))

func exit():
	pass

func update():
	mouse_pos += owner.owner.get_global_mouse_position() - Vector2(384, 256)
	var mouse_speed = mouse_pos - previous_mouse_pos
	owner.velocity = lerp(owner.velocity, (mouse_speed * 25), 0.01)
	previous_mouse_pos = mouse_pos
	Input.warp_mouse(Vector2((get_viewport().size.x / 2), (get_viewport().size.y / 2)))
	
	if Input.is_action_just_pressed("Click") and owner.options.modifier_burst:
		owner.velocity = -owner.velocity
		owner.get_node("Sounds").get_node("sfxBurstLaunched").play()

