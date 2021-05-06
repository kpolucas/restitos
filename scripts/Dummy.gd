extends KinematicBody2D

var health = 100

signal damaged(newHealth)

func _process(delta):
	if health <= 0:
		queue_free()

func OnHit(damage):
	print("player hit enemy")
	health -= damage
	emit_signal("damaged",health)
