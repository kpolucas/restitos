extends Control

onready var playerRef = get_node("/root/Main/World/Player")
onready var bossRef =  get_node("/root/Main/World/BossDuolon")

func _on_Player_damaged():
	$HealthBar/TextureProgress.value = playerRef.health


func _on_BossDuolon_damaged():
	$HealthBarBoss/TextureProgress.value = bossRef.health
