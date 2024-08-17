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
	

func cut(ind,delseg = true):
	if(ind == 0 or ind >= cols.size()):
		return
	length = ind
	if(delseg):
		cols[ind].queue_free()
	var body = BODY.instantiate()
	for i in range(ind + int(delseg),cols.size()):
		cols[i].reparent(body)
		cols[i].cut.disconnect(cut)
	get_parent().add_child.call_deferred(body)

func move(dir):
	var ray : RayCast2D
	if(dir.x > 0): ray = %right
	elif(dir.x < 0): ray = %left
	elif(dir.y > 0): ray = %down
	else: ray = %up
	
	if(ray.is_colliding()):
		return
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
	if(not is_on_floor()):
		return
	if(event.is_action_pressed("right")):
		dir.x = grid_scale.x
	elif(event.is_action_pressed("left")):
		dir.x = -grid_scale.x
	elif(event.is_action_pressed("up")):
		dir.y = -grid_scale.y
	elif(event.is_action_pressed("down")):
		dir.y = grid_scale.y
	else:
		return
	
	#frameedit = true
	plannedmoves.append(dir)
	if($cooldown.is_stopped()):
		_on_cooldown_timeout()
		$cooldown.start()
	if(plannedmoves.size() >= 3):
		plannedmoves.pop_front()
	


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
		cols[i].modulate = lerp(Color.GREEN,Color.RED,float(i) / cols.size())
	length = cols.size()
	cols[0].ishead = true
	cols[-1].isend = true
	frameedit = false
	#print($CharacterBody2D.is_on_floor())


func _on_cooldown_timeout() -> void:
	if(plannedmoves.is_empty()):
		$cooldown.stop()
		return
	move(plannedmoves.pop_front())
