extends CharacterBody2D



var dir = 1
@export var speed :float= 60
var t = 0


func _physics_process(delta: float) -> void:
	t += delta * 12
	$ColorRect.rotation_degrees = 10 * abs(velocity.x) / float(speed) * sin(t)
	if(not $idle.is_stopped()):
		velocity.x = lerp(velocity.x,0.0,0.1)
		return
	
	velocity.y = 10/delta
	velocity.x = lerp(velocity.x,speed * dir,0.2)
	
	
	
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	dir *= -1
	$idle.start()
