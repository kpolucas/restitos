extends KinematicBody2D

var health = 500

export (PackedScene) var attackEffect 
var flashI = 0
var actions = ["gancho","kick","sweep","mirror","explosion"]
#var actions = ["mirror"]
var lastAttack
var nextAttack
var rng = RandomNumberGenerator.new()
signal damaged

onready var attackEffectPoint = $Sprite/AttackEffectPoint
onready var Player = get_node("/root/Main/World/Player")
onready var anim = $AnimationTree.get("parameters/playback")
onready var currentAnimation


func _ready():
	rng.randomize()


func _process(delta):
	_flash_decay()
	
	if health <= 0:
		anim.travel('dying')
		return
	
	var currentAnimation = anim.get_current_node()
	match currentAnimation:
		'dying':
			pass
		'intro':
			pass
		'idle':
			if $IdleTimer.is_stopped():
				#$IdleTimer.start(5) # mejorable
				$IdleTimer.start(rng.randi_range(1,4))
		'teleportOut':
			pass
		'teleportIn':
			pass
		'gancho':
			pass
		'kick':
			pass
		'sweep':
			pass
		'mirror':
			pass
		'explosion':
			pass
		'stunned':
			pass

	
func set_next_attack_position(): # se dispara desde animationPlayer teleportOut+explosion
	var newPosition
	
	if actions[0] == "mirror":
		newPosition = Vector2(100,self.get_position().y) # armar la logica mirror desp
		$Sprite.scale.x = -1
	else:
		var _playerPos = Player.get_position().x
		var offSet = rng.randf_range(-55.0, 55.0)
		newPosition = Vector2(_playerPos + offSet , self.get_position().y)
		$Sprite.scale.x = -1 if offSet < 0 else 1
	self.set_position(newPosition) 
	
	
func instantiate_attack_effect(): # se dispara desde animationPlayer sweep,gancho,kick,etc
	var attackEffectInstance = attackEffect.instance()
	add_child(attackEffectInstance)
	attackEffectInstance.global_position = attackEffectPoint.global_position
	attackEffectInstance.global_rotation_degrees = attackEffectPoint.global_rotation_degrees
	

func _flash_start():
	$Sprite.material.set_shader_param("flashIntensity" ,1.0)
	flashI = 1.0
func _flash_decay():
	if flashI >= 0:
		flashI -= 0.1
		$Sprite.material.set_shader_param("flashIntensity" , flashI)


func player_hit_enemy(damage):
	health -= damage
	_flash_start()
	# $DamageParticles.emitting = true # TODO
	emit_signal("damaged")


func _on_IdleTimer_timeout():
	actions.shuffle()
	lastAttack = nextAttack
	nextAttack = actions[0]
	anim.travel(nextAttack)
	
