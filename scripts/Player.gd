extends KinematicBody2D

# fuente https://www.youtube.com/watch?v=xFEKIWpd0sU
const UP = Vector2(0,-1)
const BACKDASH = Vector2(-1000,-300) 
const GRAVITY = 60
const MAXFALLSPEED = 200
const MAXSPEED = 200
const JUMPFORCE = 600
const ACCEL = 20
const STOPFRICTION = 0.2

var motion = Vector2()
var facing_right = true


func _ready():
	$AnimationPlayer.play("idle") # Replace with function body.

func _process(delta):
	pass
# run every frame
func _physics_process(delta):
	
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	#TODO Manejar el input y el facing desde aca o desde _process?
	if facing_right:
		$Sprite.scale.x = 2
	else:
		$Sprite.scale.x = -2
		
	
	if Input.is_action_pressed("right"): 
		motion.x += ACCEL
		facing_right = true
	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL
		facing_right = false
	else:
		motion.x = lerp(motion.x,0,STOPFRICTION) # smooth de-acceleration
	motion.x = clamp(motion.x,-MAXSPEED,MAXSPEED) # cap on the maxspeed
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMPFORCE
		if Input.is_action_just_pressed("backdash"):
			if facing_right:
				motion.x = BACKDASH.x
			else:
				motion.x = -BACKDASH.x
			motion.y = BACKDASH.y
	
		
	motion = move_and_slide(motion,UP) 
