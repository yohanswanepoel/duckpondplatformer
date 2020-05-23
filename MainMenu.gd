extends Control

var play_Button = null
var quit_Button = null
# Called when the node enters the scene tree for the first time.
func _ready():
	play_Button = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/PlayButton
	quit_Button = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/QuitButton
	play_Button.grab_focus()
	quit_Button.release_focus()
	# $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/PlayButton.grab_focus()
	# $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/QuitButton.release_focus()

func _physics_process(delta):
	if play_Button.is_hovered():
		play_Button.grab_focus()
	else:
		play_Button.release_focus()
	
	if quit_Button.is_hovered():
		quit_Button.grab_focus()
	else:
		quit_Button.release_focus()


func _on_PlayButton_pressed():
	get_tree().change_scene("res://StageOne.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
	
