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
var target : Vector2
var toadd = 0

func add_tail(tail = null,ext = false):
	if(not tail):
		tail = TAIL.instantiate()
		add_child.call_deferred(tail)
	tail.ind = cols.size()
	tail.position = cols[-1].position if cols.size() > 0 else Vector2.ZERO
	cols.append(tail)
	tail.modulate = lerp(Color.WHITE,Color.BLACK,float(cols.size()) / length)
	tail.cut.connect(cut)
	tail.extend.connect(extend)
	$BodyAnimation.add_body(tail.position if not ext else cols[0].position)
	
	return tail

func get_body_poses():
	var pos = []
	for i in cols:
		pos.append(i.position)
	return pos

func _ready() -> void:
	add_tail($tail)
	$rayspos.reparent(cols[0])

func extend():
	#var t = add_tail(null,true)
	#t.position -= poses[-1]
	#plannedmoves.append(lastdir)
	#move(lastdir)
	length += 1
	

func cut(ind,delseg = true):
	if(ind == 0 or ind >= cols.size()):
		return
	length = ind
	if(delseg):
		cols[ind].queue_free()
		$BodyAnimation.body[ind].queue_free.call_deferred()
	var body = BODY.instantiate()
	for i in range(ind + int(delseg),cols.size()):
		cols[i].reparent.call_deferred(body)
		$BodyAnimation.body[i].snapobj = cols[i]
		body.get_node("body").add_body(cols[i].position,$BodyAnimation.body[i])
		#$BodyAnimation.body[i].movetarget = cols[i]
		cols[i].cut.disconnect(cut)
	while($BodyAnimation.body.size() > length):
		$BodyAnimation.body.pop_back()
	$BodyAnimation.body[-1].prevseg = null
	get_parent().add_child.call_deferred(body)

func move(dir):
	var ray : RayCast2D
	if(dir.x > 0): ray = %right
	elif(dir.x < 0): ray = %left
	elif(dir.y > 0): ray = %down
	else: ray = %up
	
	if(dir.y < 0):
		var xpos = cols[0].position.x
		var flag = false
		for i in range(1,cols.size()):
			if(abs(cols[i].position.x - xpos) <= 1e-6):
				continue
			flag = true
			break
		if(not flag):
			return
	
	if(ray.is_colliding()):
		return
	off += dir
	poses.insert(0,dir)
	#$CollisionShape2D.position = off
	#while(poses.size() > cols.size() + 1):
		#poses.pop_back()
	
	for i in min(cols.size(),poses.size()):
		cols[i].position += poses[i]
	lastdir = dir
	Manger.move.emit()
	$BodyAnimation.move()

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
	#move(dir)
	plannedmoves.append(dir)
	if($cooldown.is_stopped()):
		_on_cooldown_timeout()
		$cooldown.start()
	if(plannedmoves.size() >= 2):
		plannedmoves.pop_front()
	


func _physics_process(delta: float) -> void:
	$Node2D.position = cols[0].position
	#target = Vector2.ZERO
	#for i in [%left,%right,%down,%up]:
		#i = i as RayCast2D
		#if(i.is_colliding() and i.get_collider().is_in_group("attention")):
			#target = i.get_collider().global_postiion
			#break
	if(is_on_floor()):
		velocity.y = -10
	velocity.y += .5 / delta
	if(velocity.y >= 0):
		move_and_slide()
	
	while(cols.size() > length):
		cols.pop_back()
	while(cols.size() < length):
		var tail = add_tail()
		if(not poses.is_empty()):
			tail.position -= poses[-1]
		#move(lastdir)
	
	for i in cols.size():
		cols[i].ishead = false
		cols[i].isend = false
		cols[i].ind = i
		cols[i].modulate = lerp(Color.GREEN,Color.RED,float(i) / cols.size())
		if(i == 0):
			continue
		if(i < poses.size()):
			cols[i].global_position = cols[i - 1].global_position - poses[i - 1]
	length = cols.size()
	cols[0].ishead = true
	cols[-1].isend = true
	frameedit = false
	$BodyAnimation.init = false
	#print($CharacterBody2D.is_on_floor())


func _on_cooldown_timeout() -> void:
	if(plannedmoves.is_empty()):
		$cooldown.stop()
		return
	move(plannedmoves.pop_front())
