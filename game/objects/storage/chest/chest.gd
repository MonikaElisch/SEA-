extends Node3D
@onready var animationPlayer =$AnimationPlayer


#func _process(delta)-> void:
	

func _on_lock_body_entered(body: Node3D) -> void:
	print(body.name)
	if body.is_in_group("keys"):
		animationPlayer.play("open")
