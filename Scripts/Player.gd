extends KinematicBody2D

var motion = Vector2()
var facing_right = true

# Health
var health = 100
# Movement
export var BACKDASH = Vector2(-1500,-300) 
export var GRAVITY = 60
export var MAXFALLSPEED = 750
export var MAXSPEED = 180
export var JUMPFORCE = 850
export var ACCEL = 65
export var STOPFRICTION = 0.25
# Attack
var attack123 = 1
# Block
export var canParry = false
var knockback = 0
var knockbackFriction = 0.15

onready var playerSpriteMaterial = $PlayerSprite.material
onready var playerAnimationTree = $PlayerAnimationTree.get("parameters/playback")


func _physics_process(delta):
	_movement()
	_direction()
	_attack()
	_block()

func _movement():
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	knockback = lerp(knockback,0,knockbackFriction)
	motion.x -= knockback
	
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
	if Input.is_action_just_released("jump") && motion.y < 0:
		motion.y = 0
		
	if Input.is_action_just_pressed("backdash") && is_on_floor():
		motion.x = BACKDASH.x if facing_right else -BACKDASH.x
		motion.y = BACKDASH.y
		playerAnimationTree.travel("backdash")
			
	motion = move_and_slide(motion,Vector2.UP)

func _direction():
	$PlayerSprite.scale.x = -1 if facing_right else 1
	$PlayerSprite.position.x = 16 if facing_right else -16 # Centro el placeholder

func _attack():
	if Input.is_action_just_pressed("attack"):
		if attack123 <= 3:
			$AttackRestart.start()	
		match attack123:
			1:
				playerAnimationTree.travel("attack123-1")
			2:
				playerAnimationTree.travel("attack123-2")
			3:
				playerAnimationTree.travel("attack123-3")
		attack123 += 1
			
func _block():
	if Input.is_action_just_pressed("block"):
		playerAnimationTree.travel("block")
	if Input.is_action_just_released("block"):
		canParry = false
		playerAnimationTree.travel("idle")

func OnHit(damage,kb):
	if Input.is_action_pressed("block"):
		damage = 0
	else:
		playerAnimationTree.travel("damaged")
	knockback = kb
	health -= damage
	print("Player health: " + str(health))

func _on_AttackRestart_timeout():
	attack123 = 1
