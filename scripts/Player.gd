extends KinematicBody2D

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


func _ready():
	$AnimationPlayer.play("idle") # Replace with function body.
# run every frame
func _physics_process(delta):
	_movement()
	_attack()
	_animation()
	
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
			
	motion = move_and_slide(motion,UP) 

func _attack():
	pass

func _animation():
	if Input.is_action_just_pressed("attack"):
		$AnimationPlayer.play("attack")
	
	if facing_right:
		$Sprite.scale.x = 2
	else:
		$Sprite.scale.x = -2
		


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		$AnimationPlayer.play("idle")

func _on_SwordArea_body_entered(body):
	#if body.is_in_group("ble"):
	body.OnHit()
