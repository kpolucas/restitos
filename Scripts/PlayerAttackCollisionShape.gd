extends CollisionShape2D

var attacksDamage = 25

func _on_Area2D_body_entered(body):
	if body.has_method("player_hit_enemy"):
		body.player_hit_enemy(attacksDamage)
