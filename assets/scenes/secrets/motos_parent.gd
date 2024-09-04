extends Node2D

var lives := 0
var score := 0

signal progress

var scenes := {
	"mTitle" : preload("res://assets/scenes/secrets/motos/motos_title.tscn"),
	"mStage1" : preload("res://assets/scenes/secrets/motos/motos_stage_template.tscn"),
	"mGameOver" : preload("res://assets/scenes/secrets/motos/motos_game_over.tscn")
}

var scene_ID := ""
var current_scene = null

func _ready():
	change_scene("mTitle", false)

func _physics_process(delta):
	if Input.is_action_just_pressed("Pause"):
		progress.emit("title", 0)
	
	$HUD/ScoreLabel.text = "Score " + str(score)
	$HUD/LivesLabel.text = "Lives " + str(lives)

func change_scene(next_scene : String, player_die : bool):
	# on scene exit
	if current_scene == null:
		pass
	else:
		match scene_ID:
			"mGameOver":
				pass
			"mTitle":
				lives = 2
			_:
				if player_die and lives > 0:
					lives -= 1
	
	if current_scene:
		current_scene.queue_free()
	scene_ID = next_scene
	var newScene = scenes[scene_ID].instantiate()
	current_scene = newScene
	await get_tree().process_frame
	add_child(newScene)
	
	newScene.motos_progress.connect(change_scene)
	
	match scene_ID:
		"mTitle":
			pass
		"mGameOver":
			newScene.get_node("Results").get_node("ScoreValue").text = "[center][wave amp=80.0 freq=4.0 connected=0]\n" + str(score)
		_:
			pass
