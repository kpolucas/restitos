extends KinematicBody2D

var health = 600
var flashI = 0

onready var bossSpriteMaterial = $BossSprite.material
onready var bossAnimationTree = $BossAnimationTree.get("parameters/playback")
onready var Player = get_node("/root/Main/World/Player")

func _process(delta):
	if health <= 0:
		queue_free()

	_flashDecay()

		
func _flashStart():
	bossSpriteMaterial.set_shader_param("flashIntensity" ,1.0)
	flashI = 1.0
func _flashDecay():
	if flashI >= 0:
		flashI -= 0.1
		bossSpriteMaterial.set_shader_param("flashIntensity" , flashI)

func _teleport():
	bossAnimationTree.travel("teleportOut")
	
func _act():
	pass

func OnHit(damage):
	health -= damage
	_flashStart()
	# $DamageParticles.emitting = true # TODO
	
	print("Enemy health: " + str(health))

func _on_AttackCooldown_timeout():
	_teleport()
	$AttackCooldown.start(3)
#	var _deltaPos = abs(self.get_position().x - Player.get_position().x)
#	if _deltaPos < 150:
#		bossAnimationTree.travel("attack1")
#	else:
#		bossAnimationTree.travel("teleport")
#		self.set_position(Vector2(Player.get_position().x , self.get_position().y)) # Desarmar en algo menos horrible
