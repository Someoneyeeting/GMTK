extends CollisionShape2D



signal cut(ind,delseg)
signal extend

var ind = -1

var ishead = false
var isend = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("cut")):
		cut.emit(ind)
	if(area.is_in_group("expand") and ishead):
		extend.emit()
		area.get_parent().queue_free()

func _physics_process(delta: float) -> void:
	$attention/CollisionShape2D.disabled = not ishead
	if(ishead):
		get_parent().target = Vector2.ZERO
		for i in $attention.get_overlapping_bodies():
			i = i as Node2D
			if(i.is_in_group("attention")):
				get_parent().target = i.global_position
				break
