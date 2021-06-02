extends CollisionShape2D

var knockback_force = 500

func _on_Area2D_body_entered(body):
	if body.has_method("OnHit"):
		if self.global_position.x > body.global_position.x:
			body.OnHit(20,knockback_force)
		else:
			body.OnHit(20,-knockback_force)
