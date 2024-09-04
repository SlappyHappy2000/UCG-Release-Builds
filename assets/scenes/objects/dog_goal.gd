extends Area2D

signal doghouse

var already_collected := false

func _ready():
	already_collected = false

func _on_body_entered(body):
	if already_collected:
		return
	doghouse.emit()
	print("dog won")
	already_collected = true
