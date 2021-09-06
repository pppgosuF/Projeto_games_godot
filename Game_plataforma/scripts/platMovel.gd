extends KinematicBody2D

var sentido = 1

func _ready():
	set_physics_process(true)
	
func _physics_process(delta):
	var new_offset = get_parent().get_unit_offset() + delta * sentido * 0.3
	if sentido == 1 and new_offset >= 0.99999:
		sentido = -1
		get_parent().set_unit_offset(0.99999)
		
	elif sentido == -1 and new_offset <= 0:
		sentido = 1
		get_parent().set_unit_offset(0)
		
	else:
		get_parent().set_unit_offset(new_offset)
