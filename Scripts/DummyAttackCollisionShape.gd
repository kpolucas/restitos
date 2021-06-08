extends CollisionShape2D

var knockback_force = 500
var attackIsParryable = true

func _on_Area2D_body_entered(body):
	if body.has_method("EnemyHitPlayer"):
		if self.global_position.x > body.global_position.x:
			body.EnemyHitPlayer(20,knockback_force,attackIsParryable)
		else:
			body.EnemyHitPlayer(20,-knockback_force,attackIsParryable)
