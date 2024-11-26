extends Node3D
@onready var animationPlayer =$AnimationPlayer


#func _process(delta)-> void:
	

func _on_lock_body_entered(body: Node3D) -> void:
	if "PickableKey" in body.name:
		animationPlayer.play("open")
