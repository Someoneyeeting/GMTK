extends Node2D


const SEGMENT = preload("res://body_seg.tscn")

@export var parent : CharacterBody2D

var body = []

var poses = []

@export var isdead = false

var init = true

func _ready() -> void:
	pass


func add_body(pos,tail :Sprite2D= null):
	if(tail == null):
		tail = SEGMENT.instantiate()
		$segments.add_child.call_deferred(tail)
	else:
		tail.reparent.call_deferred($segments)
	tail.position = pos
	tail.movetarget = pos
	if(body.is_empty()):
		body.append(tail)
	else:
		body.insert(1,tail)
	
	if(not init):
		move()
	return tail

func move():
	if(parent == null):
		return
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
	$cool.start()

func _physics_process(delta: float) -> void:
	if(isdead):
		for i in body:
			i.isdead = true
	if(parent):
		poses = parent.get_body_poses()
		#if($cool.is_stopped()):
		for i in body.size():
			body[i].update_poses(poses[i])
		
