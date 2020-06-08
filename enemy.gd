extends KinematicBody2D

# You can reuse enemy object using different speeds and animations
# This will show speed

enum ENEMY_TYPE {slow, medium, fast}
enum ENEMY_SIZE {normal, medium, big}


const GRAVITY = 10

const FLOOR = Vector2(0, -1)

var direction = 1  # Right
var velocity = Vector2(0,0)
var speed = 30
export(ENEMY_TYPE) var enemy_type = ENEMY_TYPE.slow
export(ENEMY_SIZE) var enemy_size = ENEMY_SIZE.normal

export(int) var hp = 1
# Called when the node enters the scene tree for the first time.

var is_dead = false
var size = Vector2(1,1)

func _ready():
	if enemy_type == ENEMY_TYPE.slow:
		speed = 25
	elif enemy_type == ENEMY_TYPE.medium:
		speed = 30
	elif enemy_type == ENEMY_TYPE.fast:
		speed = 40
		
	if enemy_size == ENEMY_SIZE.normal:
		size = Vector2(1,1)
	elif enemy_size == ENEMY_SIZE.medium:
		size = Vector2(2,2)
	elif enemy_size == ENEMY_SIZE.big:
		size = Vector2(3,3)
		hp = 8
	
	scale = size


func inflict(damage):
	hp -= damage
	if hp <= 0:
		is_dead = true
		rotate(1.570796)
		velocity.x = 0
		$AnimatedSprite.play("dead")
		$CollisionShape2D.call_deferred("set_disabled", true)
		$Timer.start()
		if enemy_size == ENEMY_SIZE.big:
			get_parent().get_node("ScreenShake").shake_screen(1, 10, 100)
	
	

func _physics_process(delta):
	if is_dead == false:
		$AnimatedSprite.play("walk")
		velocity.x = speed * direction
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)
		# Hit wall and turn around
		if is_on_wall():
			direction *= -1
			scale.x *= -1
		
		if $RayCast2D.is_colliding() == false:
			direction *= -1
			scale.x *= -1
			
		if get_slide_count() > 0:  #After move and slide counts all the collisions that occur
			for i in range(get_slide_count()):
				if "Player" in get_slide_collision(i).collider.name:
					get_slide_collision(i).collider.damage(50)
	
	
func _on_Timer_timeout():
	queue_free()
