extends Sprite2D

const segments = {
	"head" : preload("res://assets/head.png"),
	"body" : preload("res://assets/segment.png"),
	"tail" : preload("res://assets/tail.png")
}

var ishead = false
var isend = false
var movetarget = Vector2.ZERO
var currentpos = Vector2.ZERO
var nextseg : Sprite2D 
var prevseg : Sprite2D

func _ready() -> void:
	texture = segments["body"]
	currentpos = position
	movetarget = currentpos

func move(pos):
	currentpos = movetarget
	movetarget = pos
	if(ishead):
		pass
	$move.start()

func update_poses(pos):
	return
	if($move.is_stopped()):
		print("updated")
		currentpos = pos
		global_position = pos


func easeing(x):
	if x < 0.5:
		return (1 - sqrt(1 - pow(2 * x, 2))) / 2
	else:
		return (sqrt(1 - pow(-2 * x + 2, 2)) + 1) / 2

func _physics_process(delta: float) -> void:
	if(ishead):
		texture = segments["head"]
	elif(isend):
		texture = segments["tail"]
	else:
		texture = segments["body"]
	#print($move.time_left, $move.wait_time)
	if(not $move.is_stopped()):
		position = lerp(currentpos,movetarget,1 - easeing((float($move.time_left) / $move.wait_time)))
	else:
		position = movetarget
	
	if(isend):
		if(nextseg):
			rotation = atan2(nextseg.movetarget.y - movetarget.y, nextseg.movetarget.x - movetarget.x)
	else:
		if(prevseg):
			rotation = atan2(movetarget.y - prevseg.movetarget.y,movetarget.x - prevseg.movetarget.x)
	




func _on_move_timeout() -> void:
	currentpos = movetarget
