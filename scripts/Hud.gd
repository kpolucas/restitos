extends Control

func _on_Dummy_damaged(newHealth):
	$BossHealth.value = newHealth
