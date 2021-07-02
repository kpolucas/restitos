extends KinematicBody2D

const parryEffect = preload("res://Sprites/Effects/ParryEffect.tscn")

var motion = Vector2()
var facing_right = true

# Health
var health = 100
# Movement
export var DASH = 1500 
export var GRAVITY = 60
export var MAXFALLSPEED = 750
export var MAXSPEED = 180
export var JUMPFORCE = 850
export var ACCEL = 65
export var STOPFRICTION = 0.25
var canMoveAnims = ["walking","idle"]
# Attack

# Block
export var parry = false
var knockback = 0
var knockbackFriction = 0.15
signal parried
signal damaged

onready var playerSpriteMaterial = $PlayerSprite.material
onready var anim = $PlayerAnimationTree.get("parameters/playback")
var currentAnim


func _physics_process(delta):
	_movement()
	_direction()
	_attack()
	_block()


func _movement():
#	knockback = lerp(knockback,0,knockbackFriction)
#	motion.x -= knockback

# 	maybe
#	if anim.get_current_node() == "damaged":
#		return
		
	# THE HORROR!  Refactor ALL!
	###############################
#	if Input.is_action_pressed("right") && _can_move():
#		motion.x += ACCEL
#		facing_right = true
#		if is_on_floor():
#			anim.travel("walking")
#	elif Input.is_action_pressed("left") && _can_move():
#		motion.x -= ACCEL
#		facing_right = false
#		if is_on_floor():
#			anim.travel("walking")
#	else:
#		motion.x = lerp(motion.x,0,STOPFRICTION) # smooth de-acceleration
#	motion.x = clamp(motion.x,-MAXSPEED,MAXSPEED) # cap on the maxspeed
#
#	if abs(motion.x) < 10 && is_on_floor():
#		anim.travel("idle")
###############################
	if anim.get_current_node() in canMoveAnims:
		if Input.is_action_pressed("right") || Input.is_action_pressed("left"):
			motion.x = _walk(motion.x)
			
		if Input.is_action_just_pressed("dash"):
			motion.x = _dash(motion.x)
			
		if Input.is_action_pressed("jump") || Input.is_action_just_released("jump"):
			motion.y = _jump(motion.y)
			
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	motion.x = lerp(motion.x,0,STOPFRICTION) # smooth de-acceleration
	motion = move_and_slide(motion,Vector2.UP)


func _direction():
	if anim.get_current_node() in canMoveAnims:
		if Input.is_action_pressed("right"):
			facing_right = true
		if Input.is_action_pressed("left"):
			facing_right = false
	$PlayerSprite.scale.x = -1 if facing_right else 1
	$PlayerSprite.position.x = 16 if facing_right else -16 # Centro el placeholder


func _attack():
	currentAnim = anim.get_current_node()
	if Input.is_action_just_pressed("attack"):
		match currentAnim:
			"idle":
				anim.travel("attack123-1")
			"walking":
				anim.travel("attack123-1")
			"attack123-1":
				anim.travel("attack123-2")
			"attack123-2":
				anim.travel("attack123-3")
			_:
				pass
			
			
func _block():
	if Input.is_action_just_pressed("block"):
		anim.travel("block")
		
		
func _dash(dashMotion):
	if facing_right:
		dashMotion = DASH
		anim.travel("dash")
	else:
		dashMotion = -DASH
		anim.travel("dash")
	return dashMotion
	
	
func _walk(walkMotion):
	if Input.is_action_pressed("right"):
		walkMotion += ACCEL
	if Input.is_action_pressed("left"):
		walkMotion -= ACCEL
	return walkMotion
	

func _jump(jumpMotion):
	if Input.is_action_just_pressed("jump") && is_on_floor():
		jumpMotion = -JUMPFORCE
	if Input.is_action_just_released("jump") && motion.y < 0:
		jumpMotion = 0
	return jumpMotion


func enemy_hit_player(damage,kb,attackIsParryable):
	# ver si se puede hacer de una manera menos horrible
	if Input.is_action_pressed("block"):
		if parry && attackIsParryable:
			anim.travel("parry")
			emit_signal("parried")
			var pE = parryEffect.instance() # revisar y poner menos feo
			add_child(pE)
		else:
			knockback = kb
			
	else:
		knockback = kb * 2 # TODO cambiar dirección de la animación
		anim.travel("damaged")
		emit_signal("damaged")
		health -= damage
		print("Player health: " + str(health))
