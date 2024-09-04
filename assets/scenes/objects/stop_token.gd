extends Area2D

signal collected

func _ready():
	pass

func _physics_process(delta):
	pass

func _on_body_entered(body):
	collected.emit(0, "Boost")
	body.velocity = Vector2.ZERO
	queue_free()
