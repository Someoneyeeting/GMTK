extends CharacterBody2D



var dir = 1
@export var speed :float= 60
var t = 0
var panic = false
var currentpos
var movetarget
var mult :float= 0
var yoff :float= 0

func easeing(x):
	if x < 0.5:
		return (1 - sqrt(1 - pow(2 * x, 2))) / 2
	else:
		return (sqrt(1 - pow(-2 * x + 2, 2)) + 1) / 2

func _ready() -> void:
	Manger.move.connect(move)
	currentpos = global_position.x
	movetarget  = currentpos
	$Sprite.top_level = true
	$Sprite.global_position = global_position

func move():
	currentpos = movetarget
	position.x = currentpos
	$Sprite.global_position = global_position
	movetarget = currentpos + dir * 40
	velocity.x = 40 * dir

func _physics_process(delta: float) -> void:
	t += delta * 12 * mult
	velocity.y = 10 / delta
	
	#$CollisionShape2D.position.x = 40 * dir
	$Sprite.global_position.x = lerp(currentpos,movetarget,1 - easeing(Manger.timer.time_left / Manger.timer.wait_time))
	$Sprite.global_position.y = lerp($Sprite.global_position.y - 3.75 * 0.222 + yoff,global_position.y - 3.75 * 0.222,0.4)
	if(is_on_wall()):
		movetarget = currentpos
		velocity.x = 0
		dir *= -1
	if(is_on_ceiling()):
		print("squish")
	
	
	yoff = lerp(yoff,abs(sin(Manger.timer.time_left / Manger.timer.wait_time * PI * 1)) * -10.0,0.4)
	#$Sprite.rotation_degrees = pow(sin(Manger.timer.time_left / Manger.timer.wait_time * PI * 2),2/) * -20 * -dir
	$Sprite.flip_h = dir == -1
	
	if(Manger.timer.is_stopped()):
		velocity.x = 0
		currentpos = movetarget
		#position.x = floor(position.x / 1280.0 * 40) / 40.0 * 1280
		mult = lerp(mult,0.0,0.4)
		$Sprite.stop()
	else:
		$Sprite.play("default")
		#mult = lerp(mult,2.0,0.1)
	
	#$ColorRect.rotation_degrees = 10 * sin(t) * mult
	velocity.x /= delta
	move_and_slide()
	velocity.x = 0

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("wall")):
		dir *= -1
	if(area.global_position < global_position and area.is_in_group("squish")):
		#print("squish")
		pass
