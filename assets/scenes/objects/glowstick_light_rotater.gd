extends Node2D

@export var LightType : int

var Group1Move := 1.0

func _ready():
	for i in get_children():
		if i.name.contains(str(LightType)):
			i.visible = true
		else:
			i.visible = false

func _physics_process(delta):
	match LightType:
		1:
			Group1Move += delta * 2
			$LightGroup1/PointLight2D.global_position.y = 256 - sin(Group1Move) * 200
			$LightGroup1/PointLight2D2.global_position.y = 256 - sin(-Group1Move) * 200
		2:
			$LightGroup2.position.x += 4
			if $LightGroup2.position.x >= 512:
				$LightGroup2.position.x = 0
		3:
			$LightGroup3.rotation += 2 * delta
		4:
			$LightGroup4.rotation += 5 * delta
		5:
			$LightGroup5.rotation -= 2 * delta
