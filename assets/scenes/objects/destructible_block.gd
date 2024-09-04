extends CharacterBody2D

signal collected

func _ready():
	pass

func hit():
	collected.emit(50, "DBlock")
	queue_free()
