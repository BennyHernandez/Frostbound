extends Control

func _ready():
	var playButton = $PlayButton
	var exitButton = $ExitButton
	playButton.connect("pressed", _on_PlayButton_pressed)
	exitButton.connect("pressed", _on_ExitButton_pressed)

func _on_PlayButton_pressed():
	# Load the game scene
	var gameScene = preload("res://main.tscn")
	
	# Transition to the game scene
	get_tree().change_scene_to_file("res://main.tscn")

func _on_ExitButton_pressed():
	# Quit the game
	get_tree().quit()
