extends KinematicBody2D

var health = 200
var flashIntensity = 0
onready var anim = $AnimationPlayer
onready var bossSpriteMaterial = $BossSprite.material

func _ready():
	anim.play("idle")	
	$AttackCooldown.start()

func _process(delta):
	if health <= 0:
		queue_free()
	
	flashDecay()

		
func flash():
	bossSpriteMaterial.set_shader_param("flashIntensity" ,1.0)
	flashIntensity = 1.0
func flashDecay():
	if flashIntensity >= 0:
		flashIntensity = flashIntensity -0.1
		bossSpriteMaterial.set_shader_param("flashIntensity" , flashIntensity)

func OnHit(damage):
	health -= damage
	flash()
	$DamageParticles.emitting = true
	print("Enemy health: " + str(health))

func _on_AttackCooldown_timeout():
	anim.play("attack")
	$AttackCooldown.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		anim.play("idle")
