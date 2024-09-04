extends State

func enter(type : int = 0):
	owner.get_node("Sounds").get_node("sfxGoal").play()
	owner.get_node("HitDirection").visible = false

func exit():
	pass

func update():
	owner.velocity = lerp(owner.velocity, Vector2.ZERO, 0.05)
