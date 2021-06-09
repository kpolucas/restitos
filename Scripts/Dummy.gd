extends KinematicBody2D


onready var anim = $AnimationPlayer

func _ready():
	anim.play("attack")


func _on_Player_parried():
	anim.play("stunned")
	#shaderlindo


#negrada? revisar
func _on_AnimationPlayer_animation_finished(anim_name):
	anim.play("attack")
