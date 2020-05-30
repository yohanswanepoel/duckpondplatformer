extends Area2D

export (String, FILE, "*.tscn") var target_stage






func _on_ChangeChange_body_entered(body):
	if "Player" in body.name:
		get_tree().change_scene(target_stage) 
