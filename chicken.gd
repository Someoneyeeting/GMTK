extends CharacterBody2D



var dir = 1
@export var speed :float= 60
var t = 0
var panic = false
var currentpos
var movetarget
var mult :float= 0
var yoff :float= 0

const PART = preload("res://feathers.tscn")

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
	global_position += 40 * dir

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
	velocity.x = 0
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("wall")):
		dir *= -1
	if(area.global_position < global_position and area.is_in_group("squish")):
		#print("squish")
		pass

func _on_eaten_area_entered(area: Area2D) -> void:
	if(area.is_in_group("tail")):
		if(area.get_parent().ishead):
			area.get_parent().extend.emit()
		var part = PART.instantiate()
		get_parent().add_child(part)
		part.global_position = global_position + Vector2(0,20)
		$AnimationPlayer.play("Die")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()


func _on_timer_timeout() -> void:
	pass # Replace with function body.
