extends Area2D

func _ready():
	pass

func _process(delta):
	pass

func _on_area_entered(area):
	area.get_parent().death()
