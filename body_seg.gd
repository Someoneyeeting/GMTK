extends Sprite2D

const segments = {
	"head" : preload("res://assets/headsegment.png"),
	"body" : preload("res://assets/bodysegment.png"),
	"tail" : preload("res://assets/tailsegment.png")
}

var ishead = false
var isend = false
var movetarget = Vector2.ZERO
var currentpos = Vector2.ZERO
var nextseg : Sprite2D 
var prevseg : Sprite2D
var isdead = false
var snapobj = null
var init = false
var id = -1

func _ready() -> void:
	#texture = segments["body"]
	$ColorRect.hide()
	currentpos = position
	movetarget = currentpos

func move(pos):
	currentpos = movetarget
	movetarget = pos
	if(ishead):
		pass
	if(init):
		$move.start()

func update_poses(pos):
	movetarget = pos
	position = pos


func easeing(x):
	if x < 0.5:
		return (1 - sqrt(1 - pow(2 * x, 2))) / 2
	else:
		return (sqrt(1 - pow(-2 * x + 2, 2)) + 1) / 2

func _physics_process(delta: float) -> void:
	init = true
	if(snapobj):
		global_position = snapobj.global_position
		return
	$head.hide()
	$body.hide()
	$tail.hide()
	$Diamondpip.hide()
	$Arrow.hide()
	if(id % 5 == 0):
		$Diamondpip.show()
	$Circlepip.visible = not $Diamondpip.visible
	if(ishead):
		$head.show()
		$Diamondpip.hide()
		$Circlepip.hide()
		var targetpos = get_viewport().get_mouse_position()
		var mid :Vector2= $head/Sprite2D/leftpos.global_position + $head/Sprite2D/rightpos.global_position
		mid /= 2
		var dir = mid.direction_to(targetpos)
		$head/Sprite2D/RightEye.global_position = $head/Sprite2D/rightpos.global_position + dir * 2.5
		$head/Sprite2D/LeftEye.global_position = $head/Sprite2D/leftpos.global_position + dir * 2
	elif(isend):
		$tail.show()
	else:
		#$Arrow.show()
		var localprev :Vector2 = (prevseg.movetarget - movetarget).normalized()
		var localnext :Vector2 = (nextseg.movetarget - movetarget).normalized()
		var cross = localprev.cross(localnext)
		if(cross == 0):
			#$Arrow.show()
			$curve.hide()
			$body.show()
		else:
			$curve.show()
			#$Arrow.hide()
			$curve.flip_h = cross < 0
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
