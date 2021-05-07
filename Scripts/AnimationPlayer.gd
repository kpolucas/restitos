extends AnimationPlayer


func _ready():
	play("idle") # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		play("attack")
	if Input.is_action_just_pressed("block"):
		play("block")
	if Input.is_action_just_released("block"):
		play("idle")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		play("idle")
