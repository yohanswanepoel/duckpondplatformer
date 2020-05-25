extends KinematicBody2D


const GRAVITY = 10  # Positive as it is down in Godot
const JUMP_POWER = -250  # Negative because it is up in Godot
const FLOOR = Vector2(0, -1)

var SPEED = 60
var velocity = Vector2()
var on_ground = false
var direction = 1

var is_attacking = false
var is_dead = false

const FIREBALL = preload("res://fireball.tscn")

func _physics_process(delta):
	
	if is_dead == false:
		# Forward and Back
		if Input.is_action_pressed("ui_right"):
			# Can move if not attacking or in the air while attacking
			if is_attacking == false or is_on_floor() == false:
				velocity.x = SPEED
				# Only play animation if I am not attacking
				if is_attacking == false:
					$AnimatedSprite.play("run")
					#$AnimatedSprite.flip_h = false
					if direction < 0:
						direction = 1
						scale.x *= -1
		elif Input.is_action_pressed("ui_left"):
			# Can move if not attacking or in the air while attacking
			if is_attacking == false or is_on_floor() == false:
				velocity.x = -SPEED
				# Only play animation if I am not attacking
				if is_attacking == false:
					$AnimatedSprite.play("run")
					#$AnimatedSprite.flip_h = true
					if direction > 0:
						direction = -1
						scale.x *= -1
		else:
			velocity.x = 0
			if on_ground and is_attacking == false:
				$AnimatedSprite.play("idle")
		
		# Up and Down
		if Input.is_action_pressed("ui_up") and on_ground and is_attacking == false:
			velocity.y = JUMP_POWER
		
		# Just pressed stops holding in rapid fire
		if Input.is_action_just_pressed("ui_select") && is_attacking == false:
			if is_on_floor():
				velocity.x = 0
			is_attacking = true
			$AnimatedSprite.play("attack")
			var fireball = FIREBALL.instance()
			fireball.direction = direction
			
			fireball.position = $Position2D.global_position
			get_parent().add_child(fireball)
			
		# Gravity every frame default is 60fps
		velocity.y += GRAVITY
		
		# Check if character is on the floor - for this to work you have to set
		# the FLOOR normal on move_and_slide
		if is_on_floor():
			if on_ground == false:
				is_attacking = false
			on_ground = true
		else:
			on_ground = false
			if is_attacking == false:
				if velocity.y < 0:
					$AnimatedSprite.play("jump")
				else:
					$AnimatedSprite.play("fall")
		
		# Now move the character / remember the old velocity and set floor normal
		velocity = move_and_slide(velocity, FLOOR)
		
		if get_slide_count() > 0:  #After move and slide counts all the collisions that occur
			for i in range(get_slide_count()):
				if "enemy" in get_slide_collision(i).collider.name:
					dead()
	else:
		pass

func dead():
	is_dead = true
	rotate(1.570796)
	velocity.x = 0
	$AnimatedSprite.play("dead")
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Timer.start()
	

func _on_AnimatedSprite_animation_finished():
	is_attacking = false
	


func _on_Timer_timeout():
	get_tree().change_scene("res://MainMenu.tscn")
