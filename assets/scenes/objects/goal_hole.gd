extends Area2D

signal win

var already_collected := false

func _ready():
	already_collected = false
	$Flag.play()

func _on_body_entered(body):
	if already_collected:
		return
	win.emit()
	already_collected = true
	
