extends CharacterBody2D

@export var length = 4


var grid_scale = Vector2(40,40)

const TAIL = preload("res://tail.tscn")
const BODY = preload("res://deadbody.tscn")
var cols := []
var poses = []
var off := Vector2.ZERO
var lastdir = Vector2.ZERO
var frameedit = false
var plannedmoves = []

func add_tail(tail = null):
	if(not tail):
		tail = TAIL.instantiate()
		add_child.call_deferred(tail)
	tail.ind = cols.size()
	tail.position = cols[-1].position if cols.size() > 0 else Vector2.ZERO
	cols.append(tail)
	tail.modulate = lerp(Color.WHITE,Color.BLACK,float(cols.size()) / length)
	tail.cut.connect(cut)
	tail.extend.connect(extend)
	return tail
	
func _ready() -> void:
	
	#for i in length:
		#add_tail()
	
	add_tail($tail)
	$rayspos.reparent(cols[0])

func extend():
	var t = add_tail()
	t.position -= poses[-1]
	plannedmoves.append(lastdir)
	#move(lastdir)
	length += 1
	

func cut(ind):
	if(ind == 0 or ind >= cols.size()):
		return
	cols[ind].queue_free()
	length = ind
	if(ind != cols.size() - 1):
		var body = BODY.instantiate()
		for i in range(ind + 1,cols.size()):
			cols[i].reparent(body)
			cols[i].cut.disconnect(cut)
		get_parent().add_child.call_deferred(body)

func move(dir):
	off += dir
	poses.insert(0,dir)
	#$CollisionShape2D.position = off
	while(poses.size() > cols.size()):
		poses.pop_back()
	
	for i in min(cols.size(),poses.size()):
		cols[i].position += poses[i]
	lastdir = dir

func _input(event: InputEvent) -> void:
	var dir = Vector2.ZERO
	if(frameedit):
		return
	if(not is_on_floor()):
		return
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
	
	frameedit = true
	plannedmoves.append(dir)
	


func _physics_process(delta: float) -> void:
	$Node2D.position = cols[0].position
	velocity.y = 10 / delta
	move_and_slide()
	
	while(cols.size() > length):
		cols.pop_back()
	while(cols.size() < length):
		var tail = add_tail()
		#move(lastdir)
	
	for i in cols.size():
		cols[i].ishead = false
		cols[i].isend = false
		cols[i].ind = i
	length = cols.size()
	cols[0].ishead = true
	cols[-1].isend = true
	frameedit = false
	for i in plannedmoves:
		move(i)
	plannedmoves = []
	#print($CharacterBody2D.is_on_floor())
