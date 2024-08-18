extends Node2D


@export var target : Node2D
var pressed = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("press")):
		if(not pressed):
			press()
			pressed = true


func _physics_process(delta: float) -> void:
	var flag = false
	for i in $Area2D.get_overlapping_bodies():
		i = i as Node2D
		if(i.is_in_group("press")):
			flag = true
			break
	if(not flag):
		if(pressed):
			target.deactivate()
		pressed = false
	
	$ColorRect.visible = not pressed
		
		

func press():
	target.activate()
	
