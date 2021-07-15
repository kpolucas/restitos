extends Control

onready var playerRef = get_node("/root/Main/World/Player")
onready var bossRef =  get_node("/root/Main/World/BossDuolon")

func _ready():
	$HealthBarBoss/TextureProgress.max_value = bossRef.health
	$HealthBarBoss/TextureProgress.value = bossRef.health
	$HealthBar/TextureProgress.max_value = playerRef.health
	$HealthBar/TextureProgress.value = playerRef.health
	
func _on_Player_damaged():
	$HealthBar/TextureProgress.value = playerRef.health


func _on_BossDuolon_damaged():
	$HealthBarBoss/TextureProgress.value = bossRef.health
