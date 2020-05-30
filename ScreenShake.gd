extends Node2D

var current_shake_priority = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func move_camera(vector):
	get_parent().get_node("Player").get_node("Camera2D").offset = Vector2(rand_range(-vector.x, vector.x), rand_range(-vector.y, vector.y))
	
func shake_screen(time, pixels, priority):
	if priority > current_shake_priority:
		current_shake_priority = priority
		$Tween.interpolate_method(self, "move_camera", Vector2(pixels, pixels), Vector2(0, 0), time, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
		$Tween.start()
		


func _on_Tween_tween_completed(object, key):
	current_shake_priority = 0
