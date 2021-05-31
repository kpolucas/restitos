extends KinematicBody2D

var motion = Vector2()

export var BACKDASH = Vector2(-1500,-300) 
export var GRAVITY = 60
export var MAXFALLSPEED = 750
export var MAXSPEED = 180
export var JUMPFORCE = 850
export var ACCEL = 65
export var STOPFRICTION = 0.25

func _physics_process(delta):
	_movement()


func _movement():
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED	
	
	if Input.is_action_pressed("right"): 
		motion.x += ACCEL
	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL
	else:
		motion.x = lerp(motion.x,0,STOPFRICTION) # smooth de-acceleration
	motion.x = clamp(motion.x,-MAXSPEED,MAXSPEED) # cap on the maxspeed
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		motion.y = -JUMPFORCE
	if Input.is_action_just_released("jump") && motion.y < 0:
		motion.y = 0
		
	if Input.is_action_just_pressed("backdash") && is_on_floor():
		motion.x = BACKDASH.x 
		motion.y = BACKDASH.y
			
	motion = move_and_slide(motion,Vector2.UP)
