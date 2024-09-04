extends Node2D

signal motos_progress

func _ready():
	$Sounds/sfxGameOver.play()

func _on_sfx_game_over_finished():
	$GameOver.visible = false
	$Results.visible = true
	$Sounds/musEnd.play()
