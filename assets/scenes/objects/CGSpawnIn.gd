extends State

var test_counter := 0

func enter(type : int = 0):
	owner.get_node("Sprite2D").scale = Vector2(0.003, 0.003)
	owner.get_node("Sounds").get_node("sfxJoin").play()

func exit():
	pass

func update():
	test_counter += 1
	var starting = owner.global_position
	owner.get_node("Sprite2D").scale += Vector2(0.001, 0.001)
	if owner.get_node("Sprite2D").scale >= Vector2(0.064, 0.064):
		owner.get_node("Sprite2D").scale = Vector2(0.064, 0.064)
		if owner.options.modifier_telekinetic:
			owner.transition_to("CGMouseModifier")
		else:
			owner.transition_to("CGIdle")
		owner.spawned.emit()
		return
