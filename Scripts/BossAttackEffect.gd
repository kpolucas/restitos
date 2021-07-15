extends RigidBody2D

var knockback_force = 0
var attackIsParryable = false
var damage = 10

func _ready():
	$AnimationPlayer.play("basic")


func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()


func _on_BossAttackEffect_body_entered(body):
	if body.has_method("enemy_hit_player"):
		body.enemy_hit_player(damage,knockback_force,attackIsParryable)
