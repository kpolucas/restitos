extends KinematicBody2D

var health = 200
onready var anim = $AnimationPlayer

func _ready():
	anim.play("idle")	
	$AttackCooldown.start()

func _process(delta):
	if health <= 0:
		queue_free()

func OnHit(damage):
	health -= damage
	print("Enemy health: " + str(health))


func _on_AttackCooldown_timeout():
	anim.play("attack")
	$AttackCooldown.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		anim.play("idle")
