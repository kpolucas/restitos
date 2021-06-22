extends StaticBody2D



func _ready():
	$AnimationPlayer.play("basic")


func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()
