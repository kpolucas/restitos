extends AnimatedSprite

func _ready():
	playing = true
	
func _on_ParryEffect_animation_finished():
	queue_free()
