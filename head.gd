extends CharacterBody2D

@export var length = 4


var grid_scale = Vector2(40,40)

const TAIL = preload("res://tail.tscn")
var cols := []
var poses = []
var off := Vector2.ZERO

func _ready() -> void:
	
	for i in length:
		var tail = TAIL.instantiate()
		cols.append(tail)
		add_child(tail)
		if(i == 0):
			$rayspos.reparent(tail)
		tail.modulate = lerp(Color.WHITE,Color.BLACK,float(i) / length)

func _input(event: InputEvent) -> void:
	var dir = Vector2.ZERO
	if(event.is_action_pressed("right") and not %right.is_colliding()):
		dir.x = grid_scale.x
	elif(event.is_action_pressed("left") and not %left.is_colliding()):
		dir.x = -grid_scale.x
	elif(event.is_action_pressed("up") and not %up.is_colliding()):
		dir.y = -grid_scale.y
	elif(event.is_action_pressed("down") and not %down.is_colliding()):
		dir.y = grid_scale.y
	else:
		return
	
	off += dir
	poses.insert(0,dir)
	#$CollisionShape2D.position = off
	if(poses.size() > length):
		poses.pop_back()
	
	for i in range(poses.size()):
		cols[i].position += poses[i]
	


func _physics_process(delta: float) -> void:
	$Node2D.position = cols[0].position
	move_and_collide(Vector2(0,10))
	#print($CharacterBody2D.is_on_floor())
