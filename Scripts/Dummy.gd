extends KinematicBody2D


onready var anim = $AnimationPlayer

func _ready():
	anim.play("attack")


func _on_Player_parried():
	print("bossstunned")
	#anim.play("stunned")
	#shadelindo
