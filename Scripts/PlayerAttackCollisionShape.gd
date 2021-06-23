extends CollisionShape2D

var attacksDamage = {"idle":0, "attack123-1":20, "attack123-2":25, "attack123-3":30, "superattackrelease":50, "parryattack":100}
var currentAnimation = "idle"


func _on_Area2D_body_entered(body):
	if body.has_method("player_hit_enemy"):
		body.player_hit_enemy(attacksDamage[currentAnimation])


func _on_AnimationPlayer_animation_started(anim_name):
	currentAnimation = anim_name
