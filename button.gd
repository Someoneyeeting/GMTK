extends Node2D


@export var target : Node2D
@export var invert := false
@export var color := Color.WHITE
var pressed = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("press")):
		if(not pressed):
			press()
			pressed = true

func _ready() -> void:
	if(invert):
		target.activate()
	modulate = color
	target.modulate = color

func _physics_process(delta: float) -> void:
	var flag = false
	for i in $Area2D.get_overlapping_bodies():
		i = i as Node2D
		if(i.is_in_group("press")):
			flag = true
			break
	if(not flag):
		if(pressed):
			if(not invert):
				target.deactivate()
			else:
				target.activate()
		pressed = false
	
	$Sprite.frame = 1 if pressed else 0
		
		

func press():
	if(not invert):
		target.activate()
	else:
		target.deactivate()
	
