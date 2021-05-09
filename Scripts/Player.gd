extends KinematicBody2D

var motion = Vector2()
var facing_right = true

# Movement
export var BACKDASH = Vector2(-1000,-300) 
export var GRAVITY = 100
export var MAXFALLSPEED = 500
export var MAXSPEED = 120
export var JUMPFORCE = 700
export var ACCEL = 20
export var STOPFRICTION = 0.2
# Attack
var attack123 = 3


onready var anim = $AnimationPlayer


func _ready():
	anim.play("idle")
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
		motion.x = BACKDASH.x if facing_right else -BACKDASH.x
		motion.y = BACKDASH.y
		anim.play("backdash")
			
	motion = move_and_slide(motion,Vector2.UP) 

func _direction():
	$PlayerSprite.scale.x = -1 if facing_right else 1

func _attack():
	
	if Input.is_action_just_pressed("attack"):
		if $AttackRestart.time_left == 0:
			$AttackRestart.start()
		match attack123:
			1:
				anim.play("attack123-1")
			2:
				anim.play("attack123-2")
			3:
				anim.play("attack123-3")
		attack123 -= 1
		
	
func _block():
	if Input.is_action_just_pressed("block"):
		anim.play("block")
	if Input.is_action_just_released("block"):
		anim.play("idle")
	#anim.play("parry")

func _on_AttackRestart_timeout():
	attack123 = 3

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != "block":
		anim.play("idle")
