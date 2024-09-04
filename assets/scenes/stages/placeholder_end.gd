extends Node2D

signal progress

func _ready():
	for i in $Balls.get_children():
		i.play()

func _process(delta):
	pass
