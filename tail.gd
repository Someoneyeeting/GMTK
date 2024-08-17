extends CollisionShape2D



signal cut(ind)
signal extend

var ind = -1

var ishead = false
var isend = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("cut")):
		cut.emit(ind)
	if(area.is_in_group("longer") and ishead):
		extend.emit()
		area.queue_free()

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	pass # R
