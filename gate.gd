extends Node2D


var activated = false

func _ready() -> void:
	Manger.timer.timeout.connect(_timeout)

func activate():
	activated = true
	$AnimationPlayer.play("close")

func _timeout():
	$cut/CollisionShape2D.disabled = not activated
	#$StaticBody2D/CollisionShape2D.disabled = not activated

func deactivate():
	activated = false
	$AnimationPlayer.play_backwards("close")
