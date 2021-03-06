extends Area2D

const SPEED = 100
var velocity = Vector2()
var direction = 1
var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.x = SPEED * delta * direction  # Move and slide multiplies delta, translate does not
	translate(velocity)
	if damage == 1:
		$AnimatedSprite.play("shoot")
	elif damage == 2:
		$AnimatedSprite.play("shoot_blue")
	
	if direction < 0:
		$AnimatedSprite.flip_h = true
	
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_fireball_body_entered(body):
	if "enemy" in body.name:  # Does the string enemy exists in the body name
		body.inflict(damage)  # run the enemy dead function
		
	if body.name != "Player":
		if damage == 1:
			$AnimatedSprite.play("explode")
		elif damage == 2:
			$AnimatedSprite.play("explode_blue")
		queue_free()
	
	
