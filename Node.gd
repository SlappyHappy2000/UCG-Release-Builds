extends Node
#var next_frame = false
#var process_slowmo = false
#
#func _process(delta):
	#if get_tree().paused == false and next_frame == true:
		#get_tree().paused = true
	#
	#if get_tree().paused == false and process_slowmo == true:
		#get_tree().paused = true
		#await get_tree().create_timer(1).timeout
		#get_tree().paused = false
		#
	#if get_tree().paused == true and Input.is_action_just_pressed("1"):
		#next_frame = true
		#process_slowmo = false
		#get_tree().paused = false
		##print("next frame")
	#
	#if get_tree().paused == true and Input.is_action_just_pressed("2"):
		#process_slowmo = true
		#next_frame = false
		#get_tree().paused = false
		##print("process_slowmo")
		#
	#if Input.is_action_just_pressed("3"):
		#if get_tree().paused == false:
			#get_tree().paused = true
			##print("process paused")
		#elif get_tree().paused == true:
			#process_slowmo = false
			#next_frame = false
			#get_tree().paused = false
			##print("process unpaused")
