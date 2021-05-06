extends KinematicBody2D

var health = 100

func _ready():
	$AnimationPlayer.play("attack")	

func _process(delta):
	if health <= 0:
		queue_free()

func OnHit(damage):
	print("player hit enemy")
	health -= damage

func _on_SwordArea_body_entered(body):
	if body.is_in_group("players"): # Revisar todo lo relacionado con grupos-.
		body.OnHit() 
