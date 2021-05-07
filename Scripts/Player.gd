extends KinematicBody2D

# Revisar http://kidscancode.org/blog/2018/01/godot3_inheritance/
# fuente https://www.youtube.com/watch?v=xFEKIWpd0sU
const UP = Vector2(0,-1)
export var BACKDASH = Vector2(-1000,-300) 
export var GRAVITY = 60
export var MAXFALLSPEED = 200
export var MAXSPEED = 200
export var JUMPFORCE = 600
export var ACCEL = 20
export var STOPFRICTION = 0.2

var motion = Vector2()
var facing_right = true
var isBlocking = false
var isAttacking = false

# run every frame
func _physics_process(delta):
	_movement()
	_direction()
	_attack()
	_block()
	
func _movement():
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED	
	
	if Input.is_action_pressed("right"): 
		motion.x += ACCEL
		facing_right = true
	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL
		facing_right = false
	else:
		motion.x = lerp(motion.x,0,STOPFRICTION) # smooth de-acceleration
	motion.x = clamp(motion.x,-MAXSPEED,MAXSPEED) # cap on the maxspeed
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		motion.y = -JUMPFORCE
		
	if Input.is_action_just_pressed("backdash") && is_on_floor():
		if facing_right:
			motion.x = BACKDASH.x
		else:
			motion.x = -BACKDASH.x
		motion.y = BACKDASH.y
			
	if !isAttacking && !isBlocking:
		motion = move_and_slide(motion,UP) 

func _attack():
	if Input.is_action_just_pressed("attack"):
		isAttacking = true
	
func _block():
	if Input.is_action_just_pressed("block"):
		isBlocking = true
	if Input.is_action_just_released("block"):
		isBlocking = false

func _direction():
	if facing_right:
		$Sprite.scale.x = 1
	else:
		$Sprite.scale.x = -1

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		isAttacking = false