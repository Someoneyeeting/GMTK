extends CharacterBody2D



var dir = 1
@export var speed :float= 60
var t = 0
var panic = false
var currentpos
var movetarget
var mult :float= 0

func easeing(x):
	if x < 0.5:
		return (1 - sqrt(1 - pow(2 * x, 2))) / 2
	else:
		return (sqrt(1 - pow(-2 * x + 2, 2)) + 1) / 2

func _ready() -> void:
	Manger.move.connect(move)
	currentpos = position.x
	movetarget  = currentpos

func move():
	currentpos = movetarget
	position.x = currentpos
	movetarget = currentpos + dir * 40
	velocity.x = movetarget - currentpos
	velocity.x /= Manger.timer.wait_time

func _physics_process(delta: float) -> void:
	t += delta * 12 * mult
	velocity.y = 10 / delta
	
	if(is_on_ceiling()):
		movetarget = currentpos
		velocity.x = 0
		dir *= -1
	
	if(Manger.timer.is_stopped()):
		velocity.x = 0
		currentpos = movetarget
		position.x = movetarget
		mult = lerp(mult,0.0,0.4)
	else:
		mult = lerp(mult,2.0,0.1)
	
	$ColorRect.rotation_degrees = 10 * sin(t) * mult
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	dir *= -1
	if(not panic):
		$idle.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("tail")):
		panic = true
