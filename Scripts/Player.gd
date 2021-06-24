extends KinematicBody2D

const parryEffect = preload("res://Sprites/Effects/ParryEffect.tscn")

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
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	knockback = lerp(knockback,0,knockbackFriction)
	motion.x -= knockback

# 	maybe
#	if anim.get_current_node() == "damaged":
#		return

	# THE HORROR!  Refactor ALL!
	if Input.is_action_pressed("right") && _can_move():
		motion.x += ACCEL
		facing_right = true
		if is_on_floor():
			anim.travel("walking")
	elif Input.is_action_pressed("left") && _can_move():
		motion.x -= ACCEL
		facing_right = false
		if is_on_floor():
			anim.travel("walking")
	else:
		motion.x = lerp(motion.x,0,STOPFRICTION) # smooth de-acceleration
	motion.x = clamp(motion.x,-MAXSPEED,MAXSPEED) # cap on the maxspeed

	if abs(motion.x) < 10 && is_on_floor():
		anim.travel("idle")

	if Input.is_action_just_pressed("jump") && is_on_floor():
		motion.y = -JUMPFORCE
	if Input.is_action_just_released("jump") && motion.y < 0:
		motion.y = 0
		
	if Input.is_action_just_pressed("backdash") && is_on_floor():
		motion.x = BACKDASH.x if facing_right else -BACKDASH.x
		motion.y = BACKDASH.y
		anim.travel("backdash")
			
	motion = move_and_slide(motion,Vector2.UP)


func _direction():
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
		

func _can_move(): 
	if (anim.get_current_node() == "idle" || anim.get_current_node() == "walking"):
		return true
	else:
		return false


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
