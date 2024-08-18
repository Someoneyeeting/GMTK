extends Node2D


func activate():
	$AnimationPlayer.play("close")
	

func deactivate():
	$AnimationPlayer.play_backwards("close")
