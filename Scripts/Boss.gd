extends KinematicBody2D

var health = 600
var flashI = 0

onready var bossSpriteMaterial = $BossSprite.material
onready var bossAnimationTree = $BossAnimationTree.get("parameters/playback")
onready var Player = get_node("/root/Main/World/Player")

func _ready():
	randomize()

func _process(delta):
	if health <= 0:
		queue_free()

	_flash_decay()

		
func _flash_start():
	bossSpriteMaterial.set_shader_param("flashIntensity" ,1.0)
	flashI = 1.0
func _flash_decay():
	if flashI >= 0:
		flashI -= 0.1
		bossSpriteMaterial.set_shader_param("flashIntensity" , flashI)
	
func _act():
	pass

func OnHit(damage):
	health -= damage
	_flash_start()
	# $DamageParticles.emitting = true # TODO
	
	print("Enemy health: " + str(health))

func _teleport():
	var actions = ["attack1","attack2","laugh"]
	actions.shuffle()
	bossAnimationTree.travel(actions[1])
	$AttackCooldown.start(5)
	
func move_behind_player(): # se dispara desde animationPlayer teleportOut
	var _playerPos = Player.get_position().x
	var _playerFacingRight = Player.facing_right
	
	var offSet = -25 if _playerFacingRight else 25
	$BossSprite.scale.x = -1 if _playerFacingRight else 1
	
	self.set_position(Vector2(_playerPos + offSet , self.get_position().y)) # Desarmar en algo menos horrible
	
func _on_AttackCooldown_timeout():
	_teleport()
