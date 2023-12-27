extends Control

var is_paused = false : 
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		visible = is_paused
		if (is_paused):
			print("paused")
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			print("unpaused")
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event. is_action_pressed("Pause"):
		self.is_paused = !is_paused

func _on_resume_btn_pressed():
	print("resume button pressed")
	self.is_paused = false

func _on_quit_btn_pressed():
	print("quit button pressed")
	get_tree().quit()
