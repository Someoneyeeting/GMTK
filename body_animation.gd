extends Node2D


const SEGMENT = preload("res://body_seg.tscn")

@export var parent : CharacterBody2D

var body = []

var poses = []
	

func _ready() -> void:
	pass
	



func add_body(pos):
	var tail : Sprite2D = SEGMENT.instantiate()
	$segments.add_child.call_deferred(tail)
	tail.position = pos
	if(body.is_empty()):
		body.append(tail)
	else:
		body.insert(1,tail)
	return tail

func move():
	poses = parent.get_body_poses()
	for i in body.size():
		body[i].move(poses[i])
		if(i != 0):
			body[i].nextseg = body[i - 1]
		if(i != body.size() - 1):
			body[i].prevseg = body[i + 1]
		body[i].ishead = false
		body[i].isend = false
	body[0].ishead = true
	body[-1].isend = true

func _physics_process(delta: float) -> void:
	poses = parent.get_body_poses()
	for i in body.size():
		body[i].update_poses(poses[i])
		
