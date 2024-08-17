extends CollisionShape2D



signal cut(ind)

var ind = -1


func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("cut")):
		cut.emit(ind)

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	pass # R
