extends CollisionShape2D

var knockback_force = 500
var attackIsParryable = true
var damage = 20

func _on_Area2D_body_entered(body):
	if body.has_method("enemy_hit_player"):
		if self.global_position.x > body.global_position.x:
			body.enemy_hit_player(damage,knockback_force,attackIsParryable)
		else:
			body.enemy_hit_player(damage,-knockback_force,attackIsParryable)
