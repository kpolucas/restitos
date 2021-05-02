extends KinematicBody2D

func _ready():
	$AnimationPlayer.play("attack")	

func OnHit():
	print("player hit enemy")


func _on_SwordArea_body_entered(body):
	if body.is_in_group("players"): # Revisar todo lo relacionado con grupos-.
		body.OnHit() 
