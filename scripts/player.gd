extends CharacterBody3D

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_pressed("Move_left"):
		translate(Vector3(-1,0,0))
	if Input.is_action_pressed("Move_right"):
		translate(Vector3(1,0,0))
	if Input.is_action_pressed("Move_forward"):
		translate(Vector3(0,0,-1))	
	if Input.is_action_pressed("Move_back"):
		translate(Vector3(0,0,1))
