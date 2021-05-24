extends KinematicBody2D

var health = 200
var flashI = 0

onready var bossSpriteMaterial = $BossSprite.material

func _process(delta):
	if health <= 0:
		queue_free()

	flashDecay()

		
func flashStart():
	bossSpriteMaterial.set_shader_param("flashIntensity" ,1.0)
	flashI = 1.0
func flashDecay():
	if flashI >= 0:
		flashI -= 0.1
		bossSpriteMaterial.set_shader_param("flashIntensity" , flashI)

func OnHit(damage):
	health -= damage
	flashStart()
	# $DamageParticles.emitting = true # TODO
	print("Enemy health: " + str(health))
