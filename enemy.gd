extends KinematicBody2D

const GRAVITY = 10
const SPEED = 30
const FLOOR = Vector2(0, -1)

var direction = 1  # Right
var velocity = Vector2(0,0)
# Called when the node enters the scene tree for the first time.

var is_dead = false


func _ready():
	pass # Replace with function body.

func dead():
	is_dead = true
	rotate(1.570796)
	velocity.x = 0
	$AnimatedSprite.play("dead")
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Timer.start()
	
	

func _physics_process(delta):
	if is_dead == false:
		$AnimatedSprite.play("walk")
		velocity.x = SPEED * direction
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)
		# Hit wall and turn around
		if is_on_wall():
			direction *= -1
			scale.x *= -1
		
		if $RayCast2D.is_colliding() == false:
			direction *= -1
			scale.x *= -1
	
	
func _on_Timer_timeout():
	queue_free()
