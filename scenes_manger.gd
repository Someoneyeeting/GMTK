extends Node2D


var win = false

@onready var music := $music

func _win():
	win = true

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("restart")):
		$AnimationPlayer.play("restart")


func _next():
	pass

func _restart():
	get_tree().reload_current_scene()
